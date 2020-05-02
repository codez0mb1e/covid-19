
keras::install_keras()
library(keras)



## ----

train_params <- list(
  epochs_n = 1e3,
  n_timesteps = forecast_horizont, # length of the hidden state 
  n_predictions = forecast_horizont,
  batch_size = 64L
)




## ----

x <- data %>% 
  ## prepare
  group_by(country) %>% 
  arrange(date) %>% 
  ## calc active cases
  mutate(
    active_n = confirmed_n - recovered_n - deaths_n
  ) # %>% 
  # TODO:
  ## calculate cases per 1M population
  #mutate_at(
  #  vars(ends_with("_n")),
  #  list("per_1M" = ~ ./population*1e6)
  #)



## ----

#'
#' Calculate date when...
#'
get_date_when <- function(dt, .case_type, .threshold) {
  require(dplyr)
  
  stopifnot(
    is.data.frame(dt),
    is.character(.case_type),
    is.numeric(.threshold)
  )
  
  dt %>% 
    group_by(country) %>% 
    filter_at(vars(.case_type), ~ . >= .threshold) %>% 
    summarise(since_date = min(date))
}


x %<>% 
  ## confirmed events
  inner_join(
    x %>% get_date_when("confirmed_n", 1) %>% rename(since_1st_confirmed_n_days = since_date), # TODO: confirmed_n_per_1M
    by = "country"
  ) %>% 
  inner_join(
    x %>% get_date_when("confirmed_n", 100) %>% rename(since_100th_confirmed_n_days = since_date),
    by = "country"
  ) %>% 
  ## recovered events
  inner_join(
    x %>% get_date_when("recovered_n", 1) %>% rename(since_1st_recovered_n_days = since_date),
    by = "country"
  ) %>% 
  inner_join(
    x %>% get_date_when("recovered_n", 100) %>% rename(since_100th_recovered_n_days = since_date),
    by = "country"
  ) %>% 
  ## deaths events
  inner_join(
    x %>% get_date_when("deaths_n", 1) %>% rename(since_1st_deaths_n_days = since_date),
    by = "country"
  ) %>% 
  inner_join(
    x %>% get_date_when("deaths_n", 10) %>% rename(since_10th_deaths_n_days = since_date),
    by = "country"
  ) %>% 
  ## calc days number
  mutate_at(
    vars(starts_with("since_")), 
    list(~ difftime(date, ., units = "days") %>% as.numeric)
  ) %>% 
  mutate_at(
    vars(ends_with("_n_days")),
    list(~ if_else(. > 0, ., 0))
  )



## ----

x %<>% 
  ## calc lags
  mutate_at(
    vars(ends_with("_n")), 
    list("lag_7d" = ~ lag(., 7))
  ) %>% 
  mutate_at(
    vars(ends_with("_n")), 
    list("lag_8d" = ~ lag(., 8))
  ) %>%
  mutate_at(
    vars(ends_with("_n")), 
    list("lag_9d" = ~ lag(., 9))
  ) %>%
  mutate_at(
    vars(ends_with("_n")), 
    list("lag_10d" = ~ lag(., 10))
  )

  

## ----
  
x %<>% 
  ungroup %>% 
  filter(date <= last_observation_date + days(forecast_horizont)) %>% 
  mutate(
    country = factor(country),
    label = if_else(date > last_observation_date, 0L, confirmed_n)
  ) %>% 
  select(-ends_with("_n")) %>% 
  na.omit

stopifnot(
  !anyNA(x)
)

x %>% skim

View(
  x %>% filter(country == "US") %>% select(country, date, label, contains("confirmed"))
)



## Normalize data ----
x %<>% mutate_if(is.numeric, log1p)

train_dt <- x %>% 
  filter(date <= last_observation_date - days(forecast_horizont))

test_dt <- x %>% 
  apply_test_only_filter



get_scale_attr <- function(dt) {
  s_dt <- dt %>% 
    select_if(is.numeric) %>% 
    scale
  
  list(
    mean = attr(s_dt, "scaled:center") ,
    std = attr(s_dt, "scaled:scale")
  )
}

apply_scale_attr <- function(dt, .attr) {
  cbind(
    # country, date
    dt %>% 
      transmute(country = as.integer(country), date) %>% 
      as.matrix, 
    # scaling other columns
    scale(
      dt %>% select_if(is.numeric), 
      center = .attr$mean, scale = .attr$std
    )
  )
}



scale_attr <- get_scale_attr(train_dt)

label_indx <- which(names(test_dt) == "label")

train_dt %<>% apply_scale_attr(scale_attr)
test_dt %<>% apply_scale_attr(scale_attr)

# TODO: i need numeric!
str(test_dt[, label_indx])
str(train_dt[, label_indx])


train_dt %>% skim
test_dt %>% skim



##  ----
x_train <- cbind(
  to_categorical(train_dt[, 1]), 
  train_dt[, -c(1:2, label_indx)]
)

dim(x_train)

y_train <- train_dt[, label_indx]
y_train %>% tail


x_test <- cbind(
  to_categorical(test_dt[, 1]), 
  test_dt[, -c(1:2, label_indx)]
)

dim(x_test)

y_test <- test_dt[, label_indx]
y_test %>% tail



# ----

model <- keras_model_sequential() %>%
  layer_dense(units = 64, activation = "relu", input_shape = dim(x_test)[2]) %>%
  layer_dropout(.2) %>% 
  layer_dense(units = 32, activation = "relu", kernel_regularizer = regularizer_l2(1e-1)) %>%
  layer_dense(units = 32, activation = "relu", kernel_regularizer = regularizer_l2(1e-1)) %>%
  layer_dropout(.2) %>% 
  layer_dense(units = 1)

model %>% compile(
  loss = "mse",
  optimizer = optimizer_rmsprop(),
  metrics = list("mse", "mae")
)

model %>% summary()


history <- model %>% fit(
  x_train, y_train,
  epochs = train_params$epochs_n,
  validation_split = .2
)

plot(history)


## Eval
model %>% evaluate(x_train, y_train)
model %>% evaluate(x_test, y_test)


#> model %>% evaluate(x_train, y_train)
# loss: 0.1348 - mean_squared_error: 0.1335 - mean_absolute_error: 0.0598
#> model %>% evaluate(x_test, y_test)
# loss: 1.3073 - mean_squared_error: 1.3059 - mean_absolute_error: 0.4435


## Predict
pred_keras <- model %>% predict(x_test)
pred_keras %>% tail


# unscale
label_scale_attr <- scale_attr %>% map(~ .["label"])
label_scale_attr

pred_fcnn <- data %>% 
  inner_join(
    x %>% apply_test_only_filter %>% select(country, date),
    by = c("country", "date")
  ) %>% 
  mutate(
    pred = exp(pred_keras[, 1] * label_scale_attr$std + label_scale_attr$mean) - 1
  ) %>% 
  select(
    country, date, ends_with("_n"), pred
  )


## Eval
MALE(pred_fcnn$confirmed_n, pred_fcnn$pred)
RMSLE(pred_fcnn$confirmed_n, pred_fcnn$pred)



# LSTM  ------------
# https://blogs.rstudio.com/tensorflow/posts/2018-06-25-sunspots-lstm/
# https://blogs.rstudio.com/tensorflow/posts/2017-12-20-time-series-forecasting-with-recurrent-neural-networks/
# https://codingclubuc3m.rbind.io/post/2018-11-27/


# functions used
build_matrix <- function(ts, overall_timesteps) {
  t(
    sapply(
      1:(length(ts) - overall_timesteps + 1),
      function(x) ts[x:(x + overall_timesteps - 1)]
    )
  )
}

reshape_3d <- function(x) {
  dim(x) <- c(dim(x)[1], dim(x)[2], 1)
  x
}


# extract values from data frame
train_v <- data %>% 
  ## prepare
  filter(country == "US") %>% 
  group_by(country) %>% 
  arrange(date) %>% 
  ## get train dataset
  filter(date <= last_observation_date) %>% 
  select(confirmed_n) %>%
  pull


# build the windowed matrices
train_m <- build_matrix(train_v, train_params$n_timesteps + 1)
dim(train_m)

View(train_m)


x_train <- train_m[, 1:train_params$n_timesteps]
x_train[dim(x_train)[1], ]

y_train <- train_m[, train_params$n_timesteps + 1]
y_train[length(y_train)]





FLAGS <- flags(
  # There is a so-called "stateful LSTM" in Keras. While LSTM is stateful
  # per se, this adds a further tweak where the hidden states get 
  # initialized with values from the item at same position in the previous
  # batch. This is helpful just under specific circumstances, or if you want
  # to create an "infinite stream" of states, in which case you'd use 1 as 
  # the batch size. Below, we show how the code would have to be changed to
  # use this, but it won't be further discussed here.
  flag_boolean("stateful", FALSE),
  # Should we use several layers of LSTM?
  # Again, just included for completeness, it did not yield any superior 
  # performance on this task.
  # This will actually stack exactly one additional layer of LSTM units.
  flag_boolean("stack_layers", FALSE),
  # number of samples fed to the model in one go
  #! flag_integer("batch_size", 10),
  # size of the hidden state, equals size of predictions
  flag_integer("n_timesteps", train_params$n_timesteps),
  # how many epochs to train for
  flag_integer("n_epochs", train_params$epochs_n),
  # fraction of the units to drop for the linear transformation of the inputs
  flag_numeric("dropout", 0.2),
  # fraction of the units to drop for the linear transformation of the 
  # recurrent state
  flag_numeric("recurrent_dropout", 0.2),
  # loss function. Found to work better for this specific case than mean
  # squared error
  flag_string("loss", "logcosh"),
  # optimizer = stochastic gradient descent. Seemed to work better than adam 
  # or rmsprop here (as indicated by limited testing)
  flag_string("optimizer_type", "sgd"),
  # size of the LSTM layer
  flag_integer("n_units", 128),
  # learning rate
  flag_numeric("lr", 0.003),
  # momentum, an additional parameter to the SGD optimizer
  flag_numeric("momentum", 0.9),
  # parameter to the early stopping callback
  flag_integer("patience", 10)
)


# the number of predictions we'll make equals the length of the hidden state
n_predictions <- FLAGS$n_timesteps
# how many features = predictors we have
n_features <- 1
# just in case we wanted to try different optimizers, we could add here
optimizer <- switch(FLAGS$optimizer_type,
                    sgd = optimizer_sgd(lr = FLAGS$lr, momentum = FLAGS$momentum)
)

# callbacks to be passed to the fit() function
# We just use one here: we may stop before n_epochs if the loss on the
# validation set does not decrease (by a configurable amount, over a 
# configurable time)
callbacks <- list(
  callback_early_stopping(patience = FLAGS$patience)
)



model <- keras_model_sequential()

model %>%
  layer_lstm(
    units = FLAGS$n_units,
    batch_input_shape = c(FLAGS$batch_size, FLAGS$n_timesteps, n_features),
    dropout = FLAGS$dropout,
    recurrent_dropout = FLAGS$recurrent_dropout,
    return_sequences = TRUE,
    stateful = FLAGS$stateful
  )

if (FLAGS$stack_layers) {
  model %>%
    layer_lstm(
      units = FLAGS$n_units,
      dropout = FLAGS$dropout,
      recurrent_dropout = FLAGS$recurrent_dropout,
      return_sequences = TRUE,
      stateful = FLAGS$stateful
    )
}

model %>% time_distributed(layer_dense(units = 1))

model %>%
  compile(
    loss = FLAGS$loss,
    optimizer = optimizer,
    metrics = list("mean_squared_error")
  )

if (!FLAGS$stateful) {
  model %>% fit(
    x = x_train,
    y = y_train,
    #validation_data = list(X_valid, y_valid),
    #batch_size = FLAGS$batch_size,
    epochs = FLAGS$n_epochs,
    callbacks = callbacks
  )
  
} else {
  for (i in 1:FLAGS$n_epochs) {
    model %>% fit(
      x          = x_train,
      y          = y_train,
      #validation_data = list(X_valid, y_valid),
      callbacks = callbacks,
      batch_size = FLAGS$batch_size,
      epochs     = 1,
      shuffle    = FALSE
    )
    model %>% reset_states()
  }
}

if (FLAGS$stateful)
  model %>% reset_states()


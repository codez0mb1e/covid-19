
#keras::install_keras()
library(keras)


source("core.R")
theme_set(theme_bw())



# Set train params ----

forecast_h <- 1L

n_features <- 2L

n_timesteps <- 1L # since we are using stateful RNN @n_timesteps can be set to 1
batch_size <- 50L
n_epochs <- 10L
layer_units <- list(L1 = 50L, L2 = 50L)
dropout <- .2

verbose <- 1



# Load datasets ----

data <- generate_data(n = 50000, amp = 100)

# Data requirements:
# * has column y as label
# * has column timestamp as time index
# * ordered by timestamp (desc)
# * all features are numeric
# * last column is y
# * dataframe not contains NAs

data %<>% arrange(timestamp) 

ggplot(data, aes(timestamp)) +
  geom_jitter(aes(y = x1), alpha = .75, size = .1, color = "grey") +
  geom_jitter(aes(y = x2), alpha = .75, size = .1, color = "gold") +
  geom_line(aes(y = y), color = "red") 
  
  


# Prepare dataset ----

## Split
splitter <- get_splitter(data$timestamp, .ratio = c(.65, .15))
splits <- data %>% apply_splitter(splitter, .verbose = verbose)


## Normalization
scaler <- splits$train %>% get_scaler
scaler

splits %<>% 
  map(~ .x %>% apply_scaler(scaler))


## Get train, valid, test datasets

# convert to matix
splits %<>% 
  map(~ .x %>% select(-timestamp) %>% as.matrix)


# Xs
X <- splits %>% 
  map(
    function(.x) {
      # get features
      m <- .x[, 1:n_features]
      
      # set dimensions
      if (is.null(dim(m))) {
        dim(m) <- c(length(m), 1, n_features)
      } else {
        dim(m) <- c(dim(m)[1], 1, n_features)
      }
      
      stopifnot(
        length(m) > 0,
        length(dim(m)) == 3,
        !anyNA(m),
        is.numeric(m)
      )
      
      m
    }
  )


# Ys
Y <- splits %>% 
  map(
    function(.x) {
      # get label
      m <- .x[, n_features + 1]
      
      # set dimensions
      dim(m) <- c(length(m), 1)
      
      stopifnot(
        length(m) > 0,
        length(dim(m)) == 2,
        !anyNA(m),
        is.numeric(m)
      )
      
      m
    }
  )


stopifnot(
  all(map2_lgl(X, Y, ~ dim(.x)[1] == dim(.y)[1])),
  dim(X$test)[2:3] == dim(X$train)[2:3],
  dim(Y$test)[2] == dim(Y$train)[2]
)


ggplot(tibble(id = 1:length(Y$train[, 1]), value = Y$train[, 1])) +
  geom_line(aes(x = id, y = value))

ggplot(tibble(id = 1:length(Y$test[, 1]), value = Y$test[, 1])) +
  geom_line(aes(x = id, y = value))





# Train model ----

## Architecture

model <- keras_model_sequential()

model %>%
  layer_lstm(units = layer_units$L1, 
             batch_input_shape = c(batch_size, n_timesteps, n_features),
             return_sequences = T, stateful = T) %>% 
  layer_dropout(rate = dropout) %>% 
  layer_lstm(units = layer_units$L2, return_sequences = F, stateful = T) %>% 
  layer_dropout(rate = dropout) %>% 
  layer_dense(units = 1)

model %>% 
  compile(
    loss = "mean_squared_error",
    optimizer = optimizer_rmsprop(lr = 1e-2),  
    metrics = c("mae")
  )

summary(model)



## Fit

for (i in 1:n_epochs) {
  model %>% fit(X$train, Y$train, 
                validation_data = list(X$valid, Y$valid),
                batch_size = batch_size, epochs = 1, shuffle = F,
                verbose = verbose)
  
  model %>% reset_states()
}


## Predict

pred <- model %>% predict(X$test, batch_size = batch_size)

stopifnot(
  dim(pred)[1:2] == dim(Y$test)[1:2],
  !anyNA(pred)
)


## Eval model
scores <- score_predictions(data, Y$test[, 1], pred[, 1], scaler, splitter)

stopifnot(
  nrow(scores %>% inner_join(data, by = "timestamp")) == length(Y$test[, 1]),
  nrow(scores %>% inner_join(data, by = "timestamp") %>% filter(abs(y - actual) > 1e-3)) == 0
)


RMSE(scores$actual, scores$pred) 
# pure: 0.3916269
# add x2: 0.5279518


ggplot(scores[-(1:batch_size), ], aes(timestamp)) +
  geom_jitter(aes(y = pred), alpha = .5, size = .1) +
  geom_line(aes(y = actual), color = "red") 



## GC
rm(model)



print("Script needs installed tidycovid19 package https://github.com/joachim-gassen/tidycovid19")

data <- tidycovid19::download_merged_data(silent = T, cached = T)

write.table(data, "../data/tidycovid19-package-data.csv",
            append = F, quote = F, sep = ",", na = "", 
            row.names = F, col.names = T, 
            fileEncoding = "utf-8")

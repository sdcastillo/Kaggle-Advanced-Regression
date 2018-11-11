#source: https://stackoverflow.com/questions/38620424/label-encoder-functionality-in-r

# function which returns function which will encode vectors with values  of 'vec' 
label_encoder = function(vec){
  levels = sort(unique(vec))
  function(x){
    match(x, levels)
  }
}


colors = c("red", "red", "blue", "green")

color_encoder = label_encoder(colors) # create encoder

encoded_colors = color_encoder(colors) # encode colors
encoded_colors

new_colors = c("blue", "green", "green")  # new vector
encoded_new_colors = color_encoder(new_colors)
encoded_new_colors

other_colors = c("blue", "green", "green", "yellow") 
color_encoder(other_colors) # NA's are introduced

# save and restore to disk
saveRDS(color_encoder, "color_encoder.RDS")
c_encoder = readRDS("color_encoder.RDS")
c_encoder(colors) # same result

# dealing with multiple columns

# create data.frame
set.seed(123) # make result reproducible
color_dataframe = as.data.frame(
  matrix(
    sample(c("red", "blue", "green",  "yellow"), 12, replace = TRUE),
    ncol = 3)
)
color_dataframe

# encode each column
for (column in colnames(color_dataframe)){
  color_dataframe[[column]] = color_encoder(color_dataframe[[column]])
}
color_dataframe

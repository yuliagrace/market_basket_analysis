#Load package arules
library(arules)

#Read transactions from adventureworks
transactions <- read.transactions(file="D:\\Projects\\MBA\\MBA_data.csv",
                                  format="single",
                                  sep=",",
                                  cols=c(1,3),
                                  skip=1)

#Display some transactions data
inspect(transactions[1:10])

#Item occurrence frequency
frequency_items <- itemFrequency(transactions,
                           type="absolute")

#Sort items by frequency of occurrence
sort_items <- sort(frequency_items, decreasing=TRUE)

#Convert to dataframe
sort_items <- data.frame("SubcategoryName"=names(sort_items),
                         "Frequency"=sort_items,
                         row.names=NULL)
print(sort_items)

#Load package for colors
library(RColorBrewer)

pallete <- brewer.pal(10, "Spectral")
pallete <- colorRampPalette(pallete)(17)

#Graph of frequency of occurrence
itemFrequencyPlot(transactions,
                  type="absolute",
                  topN = 17,
                  col=pallete,
                  ylab="Frequency (Absolute)",
                  main="Absolute Item Frequency Plot")

#Association rules
mba <- apriori(transactions,
               parameter = list(support=.05,
                                confidence=.05))
inspect(mba)

#Filter berdasarkan lift
inspect(subset(mba,
               (lhs %in% "Helmets" | rhs %in% "Helmets") &
               lift > 1))

#Load package arulesviz
library(arulesViz)

#Rules Visualization
plot(subset(mba, (lhs %in% "Helmets" | rhs %in% "Helmets") &
              lift > 1), method="graph")

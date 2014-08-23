
if(!exists("tidy.means")) {
  source("./run_analysis.R")
}

build.description <- function(name) {
  description <- ""
  if(grepl("^time", name)) {
    description <- paste(description, "Time based")
  } else {
    description <- paste(description, "Frequency based")
  }
  
  if(grepl("Body", name)) {
    description <- paste(description, "body acceleration")
  } else if(grepl("Gravity", name)) {
    description <- paste(description, "gravity acceleration")
  }
    
  description
}

file.remove("CodeBook.md")

file <- "CodeBook.md"

header = "# Codebook for tidy data set\n

\t\tsubject\t\t\t\t2
\t\t  Subject identifier
\t\t    1-30              .Subject identifier
            
\t\tactivity\t\t\t\t18
\t\t  Activity name
\t\t    walking             .Measurements of subject walking
\t\t    walking.upstairs    .Measurements of subject walking upstairs
\t\t    walking.downstairs  .Measurements of subject walking downstairs
\t\t    sitting             .Measurements of subject sitting
\t\t    standing            .Measurements of subject standing
\t\t    laying              .Measurements of subject laying
"
write(c(header), file, append=TRUE)

for(name in names(tidy.means)[3:length(names(tidy.means))]) {
  line1 <- paste("\t\t", name, "     ", max(nchar(tidy.means[name][[1]])), sep = "" )
  line2 <- paste("\t\t  ", build.description(name), sep = "" )
  line3 <- paste("\t\t      ", range(tidy.means[name])[1], "..", range(tidy.means[name])[2], sep = "")
 
  write(c(line1, line2, line3, ""), file, append = TRUE)
}

#close(file)


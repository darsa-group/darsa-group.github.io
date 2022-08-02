library("googlesheets4")
library("glue")
library("dplyr")

PEOPLE_TEMPLATE_FILE <- "content/people/_people.md.template"
creds = Sys.getenv('GOOGLE_SERVICE_JSON_KEY')
people_sheet = Sys.getenv('PEOPLE_GOOGLE_SHEET_ID')
people_template = paste(readLines(PEOPLE_TEMPLATE_FILE), collapse="\n")
stopifnot(!is.null(people_template))

cat(creds,file=tmpf <- tempfile(fileext = ".json"))
gs4_auth(path=tmpf,
         scopes = "https://www.googleapis.com/auth/spreadsheets.readonly",cache=FALSE)

df <- read_sheet(people_sheet)

make_people <- function(id){
  d <- paste(tempdir(), id, sep="/")
  dir.create(d)
  row <- filter(df, id==id)
  content <-glue_data(row,people_template)
  cat(content, file= paste(d,"index.md", sep="/"))
  system(glue("curl '{row$picture_url}' > {paste(d,'featured.jpg',sep='/')}"))
  final_dir <- paste("content/people",id, sep="/")
  cmd = glue("mv {d} {final_dir}")
  system(cmd)
  }

o <- lapply(df$id, make_people)



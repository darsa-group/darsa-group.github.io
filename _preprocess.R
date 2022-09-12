library("googlesheets4")
library("glue")
library("dplyr")

PEOPLE_TEMPLATE_FILE <- "content/people/_people.md.template"

AUTO_PPL_DIR_PREFIX <- "auto-"
creds = Sys.getenv('GOOGLE_SERVICE_JSON_KEY')
stopifnot( creds != "") #, 'Could not find environment variable `GOOGLE_SERVICE_JSON_KEY`')

people_sheet = Sys.getenv('PEOPLE_GOOGLE_SHEET_ID')
stopifnot( people_sheet != "") #, 'Could not find environment variable `PEOPLE_GOOGLE_SHEET_ID`')

people_template = paste(readLines(PEOPLE_TEMPLATE_FILE), collapse="\n")
stopifnot(!is.null(people_template))

file.copy(from = creds, to=tmpf <- tempfile(fileext = ".json"))
gs4_auth(
  path=tmpf,
         scopes = "https://www.googleapis.com/auth/spreadsheets.readonly",cache=FALSE)

df <- read_sheet(people_sheet)

make_people <- function(id){
  d <- paste(tempdir(), id, sep="/")
  dir.create(d)
  row <- filter(df, id==id)
  content <-glue_data(row,people_template)
  cat(content, file= paste(d,"index.md", sep="/"))
  picture_file <- paste("assets", "image", row$picture_url, sep="/")
  dst_pict_file <- paste(d,'featured.jpg',sep='/')

  if(file.exists(picture_file)){
    file.copy(picture_file, dst_pict_file)
  }
  else{
    system(glue("curl '{row$picture_url}' > {dst_pict_file}"))
  }
  
  final_dir <- paste("content", "people",paste0(AUTO_PPL_DIR_PREFIX, id), sep="/")

  cmd = glue("rm {final_dir} -rf && mv {d} {final_dir}")
  system(cmd)
  }

o <- lapply(df$id, make_people)



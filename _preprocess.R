library("googlesheets4")
library("glue")
library("dplyr")
library("stringr")

ROLE_MAP <- c(
  masters='Master Student',
  phd='PhD Student',
  postdoc='Postdoc',
  pi='Principal Investigator'
  )


ROLE_WEIGHT <- length(ROLE_MAP):1
names(ROLE_WEIGHT) <- names(ROLE_MAP)

DEFAULT_PICTURE_FILE<- "content/people/_default_pict.png"
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
df <- filter(df, !is.na(id))


make_people <- function(id_){
  
  d <- paste(tempdir(), id_, sep="/")
  
  dir.create(d)
  row <- filter(df, id==id_)
  
  themes <- select(row, starts_with("theme_"))
  themes <- unlist(as.vector(themes))
  themes <- names(themes[themes])
  themes <- str_replace(themes,"theme_","")
  
  #tags <- c(row$role, themes)
  tags <- c(row$role)
  row$tags <- glue('[{paste(tags, collapse=", ")}]') 
  
  row$weight <- ROLE_WEIGHT[row$role]
  row$role <- ROLE_MAP[row$role]
  content <-glue_data(row,people_template)
  cat(content, file= paste(d,"index.md", sep="/"))
  dst_pict_file <- paste(d,'featured.jpg',sep='/')
  
  
  if(!is.na(row$picture_url)){
    picture_file <- paste("assets", "image", row$picture_url, sep="/")
    
    if(file.exists(picture_file)){
      file.copy(picture_file, dst_pict_file)
    }
    else{
      system(glue("curl '{row$picture_url}' > {dst_pict_file}"))
    }
  }
  else{
    warning(glue('No picture for member `{id_}`'))
    file.copy(DEFAULT_PICTURE_FILE, dst_pict_file)
    }
  
  final_dir <- paste("content", "people",paste0(AUTO_PPL_DIR_PREFIX, id_), sep="/")

  cmd = glue("rm {final_dir} -rf && mv {d} {final_dir}")
  system(cmd)
  }

o <- lapply(df$id, make_people)



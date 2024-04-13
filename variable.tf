variable rds_credentials {
  type    = object({
    username = string
    password = string
    dbname = string
  })

  default = {
    username = "shankar"
    password = "shankar123"
    dbname = "mydb"
  }

  description = "Master DB username, password and dbname for RDS"
}

package main

import (
	"net/http"
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"github.com/gin-contrib/cors"
)

var db *sql.DB;

type Credentials struct {
	Username    string  `json:"username"`
	Password 		string  `json:"password"`
}

func setupRouter() *gin.Engine {
	r := gin.Default()
	r.Use(cors.Default())

	// Simple login endpoint to check if user/pwd combination exists
	r.POST("/login", func(c *gin.Context) {
		var creds Credentials
		if err := c.BindJSON(&creds); err != nil {
			fmt.Println(err)
			return
		}

		var username string
    // Query for a value based on a single row.
    if err := db.QueryRow(`SELECT username FROM users WHERE username = $1 AND pwd = $2`, creds.Username, creds.Password).Scan(&username); err != nil {
        if err == sql.ErrNoRows {
          c.JSON(http.StatusBadRequest, "Incorrect username or password")
        } else {
					fmt.Println(err)
					c.JSON(http.StatusBadRequest, "Error")
				}
    } else {
			c.JSON(http.StatusOK, "Login success")
		}
	})

	r.POST("/register", func(c *gin.Context) {
		var creds Credentials
		if err := c.BindJSON(&creds); err != nil {
			fmt.Println(err)
			return
		}

		var username string
    // Query for a value based on a single row.
    if err := db.QueryRow(`SELECT username FROM users WHERE username = $1`, creds.Username).Scan(&username); err != nil {
        if err == sql.ErrNoRows {
					if _, err := db.Exec(`INSERT INTO users (username, pwd) VALUES ($1, $2)`, creds.Username, creds.Password); err != nil {
						panic(err)
					}
          c.JSON(http.StatusOK, "Successfully registered user!")
        } else {
					fmt.Println(err)
					c.JSON(http.StatusBadRequest, "Error")
				}
    } else {
			c.JSON(http.StatusBadRequest, "User already exists")
		}
	})

	// Private group, require authentication to access
	// private := r.Group("/private")
	// private.Use(AuthRequired)
	// {
	// 	private.GET("/me", me)
	// 	private.GET("/status", status)
	// }
	return r
}


func main() {
	// Database connection
	connStr := "host=localhost port=5432 dbname=fantasy-stock sslmode=disable"
	var err error
	db, err = sql.Open("postgres", connStr)
	
	if err != nil {
		log.Fatal(err)
	}

	// Check for connection with Ping
	err = db.Ping()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println("Connected!")

	// Listen and Server in 0.0.0.0:8080
	r := setupRouter()
	r.Run(":8080")
}

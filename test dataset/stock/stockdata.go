package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	_ "github.com/lib/pq"
)

func main() {
	res, err := http.Get("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=1min&adjusted=false&outputsize=full&apikey=" + apikey)

	if err != nil {
		log.Fatal(err)
	}
	defer res.Body.Close()

	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal(err)
	}
	//fmt.Println(string(body))
	connStr := "user=postgres password=adai dbname=stock sslmode=disable"
	// Connect to database
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	var response Response
	if err := json.Unmarshal(body, &response); err != nil {
		fmt.Println("Can not unmarshal JSON")
	}
	fmt.Println(len(response.TimeSeriesDaily))

	for time, data := range response.TimeSeriesDaily {
		//fmt.Println(time)
		stmt, err := db.Prepare("insert into stockdata (time, company, open, close) values($1, $2, $3, $4)")
		if err != nil {
			fmt.Printf("could not Insert Mesage, %v", err)
		}

		_, err = stmt.Exec(time, "IBM", data.Open, data.Close)

		if err != nil {
			fmt.Printf("could not insert mesage, %v", err)
		}
	}
	db.Close()
}

type Response struct {
	Metadata        TimeSeriesMetadata        `json:"Meta Data"`
	TimeSeriesDaily map[string]TimeSeriesData `json:"Time Series (1min)"`
}

// TimeSeriesMetadata is the metadata subset of TimeSeries
type TimeSeriesMetadata struct {
	OneInformation     string `json:"1. Information"`
	TwoSymbol          string `json:"2. Symbol"`
	ThreeLastRefreshed string `json:"3. Last Refreshed"`
	FourInterval       string `json:"4. Interval"`
	FiveOutputSize     string `json:"5. Output Size"`
	SixTimeZone        string `json:"6. Time Zone"`
}

// TimeSeriesData is a subset of TimeSeries
type TimeSeriesData struct {
	Open   float64 `json:"1. open,string"`
	High   float64 `json:"2. high,string"`
	Low    float64 `json:"3. low,string"`
	Close  float64 `json:"4. close,string"`
	Volume uint64  `json:"5. volume,string"`
}

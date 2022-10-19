package main

import (
	"encoding/hex"
	"encoding/json"
	"io/ioutil"
	"math/rand"
	"time"

	"github.com/brianvoe/gofakeit"
)

func randate() time.Time {
	randomTime := rand.Int63n(2628000) + time.Now().Unix() - 2628000 //generate time in the past month

	randomNow := time.Unix(randomTime, 0)

	return randomNow
}

func main() {
	companies := [5]string{"IBM", "AAPL", "TSLA", "AMZN", "MFC"}
	seed := time.Now().UTC().UnixNano()
	rand.Seed(seed)
	gofakeit.Seed(seed)
	userNumber := 20
	var users []User
	var leagues []UserLeague
	for i := 0; i < userNumber; i++ {
		leagueid := rand.Intn(5) + 1
		leagues = append(leagues, UserLeague{10000 + i, leagueid})
		password := []byte(gofakeit.Password(true, true, true, true, false, 5))
		users = append(users, User{10000 + i, gofakeit.LastName(), gofakeit.FirstName(), gofakeit.Email(), hex.EncodeToString(password)})
	}
	file1, _ := json.MarshalIndent(users, "", " ")
	_ = ioutil.WriteFile("users.json", file1, 0644)
	file2, _ := json.MarshalIndent(leagues, "", " ")
	_ = ioutil.WriteFile("leagues.json", file2, 0644)
	var trades []Trade
	totalTrade := 10000
	for i := 0; i < userNumber; i++ {
		count := rand.Intn(50)
		for j := 0; j < count; j++ {
			idx := rand.Int63n(5)
			company := companies[idx]
			time1 := randate()
			time2 := randate()
			buytime := time.Now()
			selltime := time.Now()
			if time1.Before(time2) {
				buytime = time1
				selltime = time2
			} else {
				buytime = time2
				selltime = time1
			}
			buy := buytime.Format("2006-01-02 15:04:05")
			sell := selltime.Format("2006-01-02 15:04:05")
			newtrade := Trade{totalTrade, 10000 + i, company, "BUY", buy}
			totalTrade += 1
			trades = append(trades, newtrade)
			newtrade = Trade{totalTrade, 10000 + i, company, "SELL", sell}
			totalTrade += 1
			trades = append(trades, newtrade)
		}
	}

	file3, _ := json.MarshalIndent(trades, "", " ")
	_ = ioutil.WriteFile("trades.json", file3, 0644)
	//fmt.Println(time.Now().String())
}

type Trade struct {
	TradeId int
	Uid     int
	Company string
	Type    string
	//Price    uint
	Time string
}

type User struct {
	Uid       int
	LastName  string
	FirstName string
	Email     string
	Password  string
}

type UserLeague struct {
	Uid      int
	LeagueId int
}

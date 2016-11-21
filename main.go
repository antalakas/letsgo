package main

import (
	"fmt"
	"time"

	"gopkg.in/kataras/iris.v4"
	redis "gopkg.in/redis.v4"
)

func getRedisConnection(address string, db int) *redis.Client {

	fmt.Println(fmt.Sprintf("Redis ip is: %s", address))
	fmt.Println(fmt.Sprintf("Database is: %d", db))

	return redis.NewClient(&redis.Options{
		Addr:         address,
		Password:     "", // no password set
		DB:           db,
		PoolSize:     20,
		PoolTimeout:  2 * time.Minute,
		IdleTimeout:  10 * time.Minute,
		ReadTimeout:  2 * time.Minute,
		WriteTimeout: 1 * time.Minute,
	})
}

func main() {

	iris.Get("/", func(c *iris.Context) {
		redisClient := getRedisConnection("redishost:6379", 0)
		redisClient.Set("hwKey", "<h1> Hello World! </h1>", 0)
		hw, _ := redisClient.Get("hwKey").Result()
		c.HTML(iris.StatusOK, hw)
	})

	iris.Listen(":8080")
}

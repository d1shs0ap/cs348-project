# Important files
### C2: SQL code
Under `db`.

### C3: `test-sample.sql`
Under `db`, along with `test-sample.out`.


# Running the application
### To start database
1. [Install PostgreSQL](https://www.postgresql.org/download/).
2. [Install Postico](https://eggerapps.at/postico/).
3. Connect to localhost.
4. Create a new database using "+ Database", name your database `fantasy-stock`.
5. Select `SQL Query`, then `Load Query...`.
6. Select `cs348-project/db/createleague.sql` in the modal popped up.
7. Run the query with "Execute Statement".

### To start server
1. [Install Go](https://go.dev/doc/install).
2. `cd server && go run main.go`

### To start client
1. Go through steps 1-3 of the [Flutter installation guide](https://docs.flutter.dev/get-started/install).
2. Open VS Code at `cs348-project/client`, then invoke `Run > Start Debugging`, selecting `web` as your chosen device. This step will make sense if you've followed step 1.


# Features
Currently, as required of C5, there are just two simple features to the application:

### User registration
The user is able to create an account with a password.

### Login
The user is able to login with the account and password created.

Please contact `m259yang[at]uwaterloo.ca` for any questions with regards to the application.

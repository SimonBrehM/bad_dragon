# BaD DRagon

Small PoC project to demonstrate full-stack NextJS integration with SQL Server through "mssql".

## Try it out 

To get this to work, create a mssql instance, run the SQL queries from `./db/`, then create a `.env.local` file at root with :

```env
DB_USER=sa
DB_PASS=my_password
DB_HOST=localhost
DB_NAME=bad_dragon
```

Alternatively, you can use the `bad_dragon.bak` file at root to restore the database from my instance.
Then run :

```bash
npm install
npm run dev
```

The website should now be available at `localhost:3000`.

# 🧾 SOP: Accessing and Querying the WordPress Database (MariaDB)
## Purpose
To provide a standardized procedure for securely connecting to, inspecting, and querying the WordPress database hosted on the DB server.
Applies to.
- DB Server: `192.168.221.130` [DB_SERVER] (MariaDB)
- Web Server: `192.168.221.129` [WEB_SERVER] (WordPress)

## Prerequisites
- SH access to the DB server
- Root or database credentials with privileges on the WordPress database (`wp_db`)
- Basic knowledge of SQL commands

## Procedure
**Step 1** — Connect to the DB Server
```
ssh root@192.168.221.130
```

**Step 2** — Log in to the MariaDB Database
```
mysql -u root -p
```
Enter the root password when prompted. I use '123456'

**Step 3** — List All Databases
```
SHOW DATABASES;
```
Verify that `wp_db` (WordPress database) exists.
`wp_db` is the db I created in my database playbook

**Step 4** — Select the WordPress Database
```
USE wp_db;
```

**Step 5** — View All Tables
```
SHOW TABLES;
```
You should see standard WordPress tables like:
```
wp_users, wp_posts, wp_comments, wp_options, etc.
```

**Step 6** — Inspect Table Structure (Optional)
To view table columns:
```
DESCRIBE wp_users;
```
or
```
SHOW COLUMNS FROM wp_users;
```

**Step 7** — Common Queries

| Purpose                  | SQL Query                                                                                                | Notes                  |
| ------------------------ | -------------------------------------------------------------------------------------------------------- | ---------------------- |
| List all WordPress users | `SELECT user_login, user_email FROM wp_users;`                                                           | Shows admin accounts   |
| View site info           | `SELECT option_name, option_value FROM wp_options WHERE option_name IN ('siteurl', 'home', 'blogname');` | Shows site title & URL |
| List all posts           | `SELECT ID, post_title, post_status FROM wp_posts WHERE post_type='post';`                               | Displays post titles   |
| Show comments            | `SELECT comment_author, comment_content FROM wp_comments;`                                               | View comments content  |
| Count number of posts    | `SELECT COUNT(*) FROM wp_posts WHERE post_type='post';`                                                  | Gives post count       |

**Step 8** — Exit MariaDB
```
EXIT;
```

**Step 9** — Exit the DB Server
```
exit
```

## Security Notes

- Never store plain-text passwords in scripts or GitHub repositories.
- Limit access to wp_user with host restrictions (e.g., `@'192.168.221.129'`).
- Regularly back up your wp_db:
```
mysqldump -u root -p wp_db > /backups/wp_db_$(date +%F).sql
```



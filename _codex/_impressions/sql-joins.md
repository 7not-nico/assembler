# SQL Joins Visual Primer

## Setup
```
users: id, name
posts: id, user_id, title
```

## Inner join — intersection
```sql
SELECT * FROM users u
JOIN posts p ON p.user_id = u.id
```

## Left join — users with or without posts
```sql
SELECT * FROM users u
LEFT JOIN posts p ON p.user_id = u.id
```

## Right join — posts with or without users
```sql
SELECT * FROM users u
RIGHT JOIN posts p ON p.user_id = u.id
```

## Full outer — everything
```sql
SELECT * FROM users u
FULL OUTER JOIN posts p ON p.user_id = u.id
```

## Anti-join — users with no posts
```sql
SELECT * FROM users u
LEFT JOIN posts p ON p.user_id = u.id
WHERE p.id IS NULL
```

## Cross join — Cartesian product
```sql
SELECT * FROM users CROSS JOIN posts
```

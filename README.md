# 🎬🍿 Flick and Feast

> Cinema chain management system with full database backend — Database course project, Universidad Nacional de Colombia, 2025.

Flick and Feast is a desktop application that simulates the management of a cinema chain. It handles ticketing, concessions, clients, subscriptions, and functions through a robust relational database backend built entirely in SQL.

---

## 🗄️ What it does

- Manage movies, functions, and screening rooms
- Handle ticket sales and seat assignments
- Track client subscriptions and loyalty programs
- Manage concession inventory and sales
- Generate reports from structured relational data

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Java (Swing) |
| Database | MySQL via JDBC |
| IDE | Apache NetBeans |
| Schema | 20 tables, 9 triggers, stored procedures |

---

## 🚀 Getting Started

### Prerequisites
- [Apache NetBeans](https://netbeans.apache.org/)
- [MySQL](https://dev.mysql.com/downloads/mysql/) installed and running
- [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) (`.jar` file)

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/DanielAlfonsoCely/Flick_and_Feast.git
   ```

2. Open in NetBeans via `File > Open Project`.

3. Add the MySQL connector:
   - Right-click the project → `Properties > Libraries > Add JAR/Folder`
   - Select `mysql-connector-j-x.x.x.jar`

4. Set your database credentials in the source:
   ```java
   String url = "jdbc:mysql://localhost:3306/flickandfeast";
   String user = "your_user";
   String password = "your_password";
   ```

5. Run the project from NetBeans.

> ⚠️ Note: the database must already exist with the required tables. SQL schema files are included in the repository.

---

## 👥 Team

Developed as a university project for the **Databases** course at **Universidad Nacional de Colombia**.

| Name | GitHub |
|---|---|
| Maria Catalina Rodriguez | [@Cata120804](https://github.com/Cata120804) |
| Juan Diego Rozo | [@jdrsajonia](https://github.com/jdrsajonia) |
| Daniel Alfonso Cely | [@DanielAlfonsoCely](https://github.com/DanielAlfonsoCely) |

---

> This repository is a reorganized fork of the [original repo](https://github.com/jdrsajonia/flick_and_feast), where some folders were compressed as `.zip` files. Here all files are extracted and browsable directly on GitHub.

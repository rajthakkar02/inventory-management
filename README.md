# 📱 MobileStock Pro — Inventory Management System

A full-featured inventory and sales management system built with **Ruby on Rails 8.1** for mobile shops. Track products, record sales, generate reports, and manage staff — all from a clean, modern dashboard.

---

## 🚀 Prerequisites

Make sure the following are installed on your system:

| Tool | Version |
|------|---------|
| **Ruby** | 4.0.4 (see `.ruby-version`) |
| **Bundler** | Latest (`gem install bundler`) |
| **SQLite3** | 3.x |
| **Node.js** | 18+ (for asset compilation) |

---

## 🛠️ Setup & Installation

```bash
# 1. Clone the repository
git clone <repository-url>
cd inventory_management

# 2. Install Ruby dependencies
bundle install

# 3. Create the database, run migrations, and seed sample data
bin/rails db:create db:migrate db:seed
```

> **Note:** The seed command creates default user accounts and sample products for testing.

---

## ▶️ Running the Application

```bash
# Start the Rails development server
bin/rails server
```

Then open your browser and navigate to: **http://localhost:3000**


## 🔐 Default Login Credentials

| Role | Email | Password |
|------|-------|----------|
| **Super Admin** | `superadmin@shop.com` | `superadmin123` |
| **Admin** | `admin@shop.com` | `admin123` |
| **Staff** | `staff@shop.com` | `staff123` |

---

## 👥 Role-Based Access

| Feature | Super Admin | Admin | Staff |
|---------|:-----------:|:-----:|:-----:|
| Dashboard | ✅ | ❌ | ❌ |
| View All Products | ✅ | ✅ | ✅ |
| Add/Edit Products | ✅ | ✅ | ❌ |
| Delete Products | ✅ | ❌ | ❌ |
| Adjust Stock (+/−) | ✅ | ✅ | ❌ |
| Record Sales | ✅ | ✅ | ✅ |
| Sales History (all users) | ✅ | ❌ | ❌ |
| Sales History (own only) | — | ✅ | ✅ |
| Today's Report | ✅ (all) | ✅ (own) | ✅ (own) |
| Monthly Report | ✅ | ❌ | ❌ |
| Financial Year Report | ✅ | ❌ | ❌ |
| Export CSV | ✅ | ❌ | ❌ |
| Staff Management | ✅ | ❌ | ❌ |

---

## ✨ Features

- **Product Management** — Add mobiles and accessories with details like IMEI, storage, color, brand
- **Stock Tracking** — Real-time stock levels with low-stock and out-of-stock alerts
- **Sales Recording** — Record sales with payment method (Cash/UPI/Card), discounts, and salesman tracking
- **Reports** — Daily, monthly, and financial year reports with payment breakdowns and top-selling products
- **CSV Export** — Export financial year sales data to CSV
- **Dark/Light Theme** — Toggle between dark and light modes
- **Responsive Design** — Works on desktop and mobile devices
- **Role-Based Access Control** — Three roles with different permission levels

---

## 🗂️ Tech Stack

- **Backend:** Ruby on Rails 8.1
- **Database:** SQLite3
- **Frontend:** Hotwire (Turbo + Stimulus), Propshaft
- **Authentication:** bcrypt (`has_secure_password`)
- **Styling:** Custom CSS with CSS variables (dark/light theme support)

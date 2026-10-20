CREATE TABLE positions (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    duty TEXT
);

CREATE TABLE categories (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE customers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    address VARCHAR(300),
    email VARCHAR(100),
    phone VARCHAR(30) NOT NULL
);

CREATE TABLE employees (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    address VARCHAR(300),
    email VARCHAR(100),
    phone VARCHAR(30) NOT NULL,
    position_id INTEGER NOT NULL,
    CONSTRAINT fk_employees_position
        FOREIGN KEY (position_id) REFERENCES positions(id)
        ON DELETE RESTRICT 
);

CREATE TABLE products (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    quantity INTEGER NOT NULL,
    weight INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    comment TEXT,
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_products_price CHECK (price >= 0),
    CONSTRAINT chk_products_quantity CHECK (quantity > 0),
    CONSTRAINT chk_products_weight CHECK (weight > 0) 
);

COMMENT ON COLUMN products.quantity IS 'Кол-во в штуках';
COMMENT ON COLUMN products.weight IS 'Вес в граммах';

CREATE TABLE orders (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'New',
    prepayment NUMERIC(10, 2) NOT NULL DEFAULT 0,
    payment NUMERIC(10, 2) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_orders_employee
        FOREIGN KEY (employee_id) REFERENCES employees(id)
            ON DELETE RESTRICT,
    CONSTRAINT chk_orders_status CHECK (
        status IN ('New', 'InProgress', 'Ready', 'Completed', 'Cancelled')
    ),
    CONSTRAINT chk_orders_prepayment CHECK (prepayment >= 0),
    CONSTRAINT chk_orders_payment CHECK (payment >= 0)
);

COMMENT ON COLUMN orders.prepayment IS 'Предоплата в рублях';
COMMENT ON COLUMN orders.payment IS 'Оплата в рублях после выполнения заказа';

CREATE TABLE order_items (
    id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT chk_order_items_price CHECK (unit_price > 0)
);

CREATE INDEX idx_employees_position ON employees(position_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_employee ON orders(employee_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_orders_status ON orders(status);

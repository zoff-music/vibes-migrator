CREATE TABLE admin_reviews (
    id BOOLEAN PRIMARY KEY DEFAULT TRUE CHECK (id),
    updated_at TIMESTAMP
);

INSERT INTO admin_reviews (id) VALUES (TRUE);

EXPLAIN ANALYZE
SELECT * FROM sinhvien WHERE email = 'thinh.ptit@email.com';

CREATE INDEX idx_sv_email ON sinhvien(email);

EXPLAIN ANALYZE
SELECT * FROM sinhvien WHERE email = 'thinh.ptit@email.com';
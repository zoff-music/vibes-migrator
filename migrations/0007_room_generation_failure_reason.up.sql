ALTER TABLE room_generations
ADD COLUMN failure_reason TEXT,
ADD CONSTRAINT room_generations_failure_reason CHECK (
	failure_reason IS NULL
	OR (
		failed_at IS NOT NULL
		AND LENGTH(failure_reason) BETWEEN 1 AND 300
	)
);

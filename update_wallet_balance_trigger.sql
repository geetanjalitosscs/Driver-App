-- Create trigger to automatically update wallet balance when earnings are added
DELIMITER $$

CREATE TRIGGER update_wallet_on_earning_insert
AFTER INSERT ON earnings
FOR EACH ROW
BEGIN
    -- Update wallet balance and total_earned
    INSERT INTO wallet (driver_id, balance, total_earned, total_withdrawn)
    VALUES (NEW.driver_id, NEW.amount, NEW.amount, 0.00)
    ON DUPLICATE KEY UPDATE
        balance = balance + NEW.amount,
        total_earned = total_earned + NEW.amount;
END$$

CREATE TRIGGER update_wallet_on_earning_update
AFTER UPDATE ON earnings
FOR EACH ROW
BEGIN
    -- Update wallet balance when earnings are modified
    UPDATE wallet 
    SET balance = balance - OLD.amount + NEW.amount,
        total_earned = total_earned - OLD.amount + NEW.amount
    WHERE driver_id = NEW.driver_id;
END$$

CREATE TRIGGER update_wallet_on_earning_delete
AFTER DELETE ON earnings
FOR EACH ROW
BEGIN
    -- Update wallet balance when earnings are deleted
    UPDATE wallet 
    SET balance = balance - OLD.amount,
        total_earned = total_earned - OLD.amount
    WHERE driver_id = OLD.driver_id;
END$$

-- Create trigger to update wallet balance when withdrawals are processed
CREATE TRIGGER update_wallet_on_withdrawal_update
AFTER UPDATE ON withdrawals
FOR EACH ROW
BEGIN
    -- Only update if status changed to 'completed'
    IF OLD.status != 'completed' AND NEW.status = 'completed' THEN
        UPDATE wallet 
        SET balance = balance - NEW.amount,
            total_withdrawn = total_withdrawn + NEW.amount
        WHERE driver_id = NEW.driver_id;
    END IF;
END$$

DELIMITER ;

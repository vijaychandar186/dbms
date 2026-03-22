-- Create the procedure
CREATE OR REPLACE PROCEDURE hello_user (p_name IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, ' || p_name || '!');
END hello_user;
/

-- Execute the procedure
BEGIN
    hello_user('World');
END;
/
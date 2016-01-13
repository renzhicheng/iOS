--创建个人表，需要进行判断，不要忘记加上IF NOT EXCEPT
CREATE TABLE IF NOT EXISTS "T_Person" (
    "id" INTEGER NOT NULL,
    "name" TEXT,
    "age" INTEGER,
    "height" REAL,
    PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "T_Company" (
"id" INTEGER NOT NULL,
"companyName" TEXT
);
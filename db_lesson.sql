* departmentsテーブルの作成

CREATE TABLE departments (
department_id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(20) NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL
);

* peopleテーブルに新しいカラムを追加

ALTER TABLE people ADD department_id INT (10) UNSIGNED AFTER email COMMENT '1が開発、2が営業、3が経理、4が人事、5が情報システム';

* 部署の追加

INSERT INTO departments (name)
VALUES 
('営業'),
('開発'),
('経理'),
('人事'),
('情報システム');

* 部署を振り分けてレコードを追加する
INSERT INTO people (name, email, age, gender, department_id)
VALUES
('イサン', 'isan@beyond-works.co.jp', 25, 1, '1'),
('ファウスト', 'fausuto@beyond-works.co.jp', 22, 2, '1'),
('ドン・キホーテ', 'donn@beyond-works.co.jp', 65, 2, '2'),
('ムルソー', 'muruso-@beyond-works.co.jp', 32, 1, '3'),
('ホンル', 'honru@beyond-works.co.jp', '29', 1, '2'),
('ヒースクリフ', 'hi-sukurrifu@beyond-works.co.jp', 21, 1, '1'),
('イシュメール', 'isyume-ru@beyond-works.co.jp', 21, 2, '5'),
('シンクレア', 'sinnkurea@beyond-works.co.jp', 18, 1, '1'),
('ロージャ', 'ro-zya@beyond-works.co.jp', 33, 2, '2'),
('ウーティス', 'utis@beyond-works.co.jp', 34, 2, '4');

* 日報の追加

INSERT INTO reports (person_id, content)
VALUES
(22, '新たな技術を使いし作品が完成まじかなりや'),
(23, '今日はあまり進捗はなかったですね'),
(24, '社用車を使って営業先に訪問した'),
(25, '異常は見受けられませんでした'),
(26, '訪問先がお休みでした〜'),
(27, '斬新なアイディアが浮かんだぞ'),
(28, '不正なアクセスを検知しました'),
(29, '既存の製品の不具合を発見しました'),
(30, '取引先からお菓子をいただいたよ'),
(31, '新しいアルバイトの申し込みが２件ありました');

* 既存の人員に部署IDを振り分ける

UPDATE people SET department_id = '1' WHERE person_id IN (1,2,3,6,15,16,17,18,19,20,21);

* 年齢の降順で男性の名前と年齢を取得する

SELECT people.name, people.age FROM people WHERE gender != 2 ORDER BY age DESC;

<!-- SELECT p.person_id, p.name, r.content FROM people p LEFT OUTER JOIN reports r USING (person_id); -->

* テーブル・レコード・カラムという3つの単語を適切に使用して、下記のSQL文を日本語で説明してください。
SELECT
  `name`, `email`, `age`
FROM
  `people`
WHERE
  `department_id` = 1
ORDER BY
  `created_at`;

  SELECTで名前、メール、年齢のカラムを指定し、
  FROMでpeopleというテーブルを指定し、
  WHEREでdepartment_idというカラムから'1'という値に一致するものを持ってきて、
  ORDER BYでデータが作成された日時（created_at）を昇順に書き換えている。

* 20代の女性と40代の男性の名前一覧を同時に取得してください。

<!-- SELECT name, age FROM people WHERE (age >= 20 AND < 30 AND gender = 2) OR (age >= 40 AND < 50 AND gender = 1); < 50 の前にもageが必要　-->
SELECT name, age FROM people WHERE (age BETWEEN 20 AND 30 AND gender = 2) OR (age BETWEEN 40 AND 50 AND gender = 1); 

* 営業部に所属する人だけを年齢の昇順で取得してください。

SELECT age FROM people WHERE department_id = 2 ORDER BY age;

* 開発部に所属している女性の平均年齢を取得してください。カラム名はaverage_ageとなるようにしましょう

SELECT AVG(age) AS average_age FROM people WHERE department_id = 1 AND gender = 2;

* 名前と部署名とその人が提出した日報の内容を同時に取得してください。（日報を提出していない人は含めない）

SELECT people.name AS '名前', departments.name AS '部署名', reports.content AS 'コメント'
FROM people INNER JOIN departments
ON departments.name = CASE people.department_id
WHEN 1 THEN '開発'
WHEN 2 THEN '営業'
WHEN 3 THEN '経理'
WHEN 4 THEN '人事'
WHEN 5 THEN '情報システム'
END
INNER JOIN reports
ON reports.person_id = people.person_id;

* 日報を一つも提出していない人の名前を取得する。

SELECT p.name, r.content FROM people p LEFT OUTER JOIN reports r USING (person_id) WHERE r.content IS NULL;
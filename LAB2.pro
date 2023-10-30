implement main
    open core, stdio, file

domains
    id = string.
    name = string.
    address = string.
    phone = string.
    aptekaName = string.
    price = integer.
    balance = integer.
    sum = integer.
    level = basic; pro.
    activeSub = ибупрофен; будесонид; парацетамол.
    pharmacyList = string*.
    buyersList = string*.

class facts - pharmacyDb
    лекарство : (id ID, name Name, price Price, activeSub ActiveSub).
    аптека : (id ID, name Name, address Address, phone Phone).
    цена_в_аптеке : (id ID, name Name, price Price, balance Balance).
    бонусная_карта : (id ID, aptekaName Name, sum Sum, level Level).
    склад : (id ID, address Address, buyersList BList, pharmacyList PList).

class predicates
    данные_аптеки : (name Name) failure.
    уровень_карты : (id Id) failure.
    прайс_лист_по_адресу : (address Address) failure.
    прайс_лист_лекарства : (name Name) failure.
    наличие_на_складе : (id Id) failure.
    лекарства_на_сумму : (sum Sum) failure.
    до_повышения_уровня : (id Id) failure.

clauses
    данные_аптеки(NAME) :-
        аптека(_, NAME, ADDRESS, PHONE),
        write("\nАдрес: ", ADDRESS, "\nНомер телефона: ", PHONE),
        nl,
        fail.

    уровень_карты(CARD_ID) :-
        бонусная_карта(CARD_ID, _, SUMMA, LEVEL),
        write("Карта ", CARD_ID, ", сумма выкупа: ", SUMMA, ", уровень: ", LEVEL),
        nl,
        fail.

    % стоимость всех лекарств в аптеке
    прайс_лист_по_адресу(ADDRESS) :-
        цена_в_аптеке(ID, NAME, PRICE, OSTATOK),
        аптека(ID, _, ADDRESS, _),
        write("\nЛекарство: ", NAME, "\nЦена:  ", PRICE, "\nОстаток: ", OSTATOK),
        nl,
        fail.

    % стоимость лекарства во всех аптеках
    прайс_лист_лекарства(NAME) :-
        цена_в_аптеке(ID, NAME, PRICE, OSTATOK),
        аптека(ID, APT_NAME, ADDRESS, _),
        write("\nАптека «", APT_NAME, "» по адресу ", ADDRESS, "\nЦена:  ", PRICE, "\nОстаток: ", OSTATOK),
        nl,
        fail.

    наличие_на_складе(ID) :-
        склад(ID, ADDRESS, BUYERS, MEDICINES),
        write("Склад ", ID, "\nАдрес склада:  ", ADDRESS, "\nПодключенные сети: ", BUYERS, "\nДоступные лекарства", MEDICINES),
        nl,
        fail.

    лекарства_на_сумму(S) :-
        лекарство(_, X, PRICE_X, _),
        лекарство(_, Y, PRICE_Y, _),
        лекарство(_, Z, PRICE_Z, _),
        SUM = PRICE_X + PRICE_Y + PRICE_Z,
        SUM < S,
        X <> Y,
        X <> Z,
        Y <> Z,
        write("Лекарства: ", X, " ", Y, " ", Z, "\nОбщая цена:  ", SUM),
        nl,
        nl,
        fail.

    % на какую сумму нужно совершить покупок владельцу карты для повыщения ее уровня
    до_повышения_уровня(ID) :-
        бонусная_карта(ID, _, SUM, basic),
        SUMMA = 50000 - SUM,
        write("Чтобы получить уровень pro, нужно совершить по карте ", ID, " покупок на сумму ", SUMMA, " у.е."),
        nl,
        nl,
        fail.

clauses
    run() :-
        consult("../pharmacy.txt", pharmacyDb),
        fail.

    run() :-
        write("_________________________________________________\n"),
        N = "Аптека.ру",
        write("Аптеки сети ", N),
        nl,
        данные_аптеки(N),
        fail.

    run() :-
        write("_________________________________________________\n"),
        уровень_карты("19350"),
        fail.

    run() :-
        write("_________________________________________________\n"),
        Addr = "ул. Карамзина, 4",
        write("Аптека по адресу:  ", Addr),
        прайс_лист_по_адресу(Addr),
        fail.

    run() :-
        write("_________________________________________________\n"),
        Lek = "Нурофен",
        write("Лекарство:  ", Lek),
        прайс_лист_лекарства(Lek),
        fail.

    run() :-
        write("_________________________________________________\n"),
        наличие_на_складе("001"),
        fail.

    run() :-
        write("_________________________________________________\n"),
        Sum = 300,
        write("Какие лекарства можно купить на ", Sum, " у.е.?\n"),
        лекарства_на_сумму(Sum),
        fail.

    run() :-
        write("_________________________________________________\n"),
        до_повышения_уровня("19349"),
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).

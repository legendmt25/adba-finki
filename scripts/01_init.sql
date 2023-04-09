-- order_status enum (pending, started, cooking, delivery, delivered)
-- basket_status enum (unpaid, clean, paid)

create table basket
(
    id     int generated always as identity primary key,
    status varchar(10)
);

create table city
(
    id   int generated always as identity primary key,
    name varchar(32) not null unique
);

create table ingredient
(
    id   int generated always as identity primary key,
    name varchar(32) not null
);

create table location
(
    id        int generated always as identity primary key,
    latitude  int not null,
    longitude int not null
);

create table locale
(
    id          int generated always as identity primary key,
    address     varchar(128) not null unique,
    location_id int          not null,
    city_id     int          not null,
    constraint fk_locale_city_id__city_id foreign key (city_id) references city (id)
        on delete set null,
    constraint fk_location_id__location_id foreign key (location_id) references location (id)
        on delete set null
);

create table menu_item
(
    id        int generated always as identity primary key,
    name      varchar(32) not null,
    cook_time int         not null,
    cost      int         not null
);

create table ingredient_x_menu_item
(
    ingredient_id int not null,
    menu_item_id  int not null,
    constraint pk_ingredient_x_menu_item primary key (ingredient_id, menu_item_id),
    constraint fk_ingredient_id__ingredient_id foreign key (ingredient_id) references ingredient (id),
    constraint fk_menu_item_id__menu_item_id foreign key (menu_item_id) references menu_item (id)
);

create table menu_item_x_basket
(
    id           int generated always as identity primary key,
    menu_item_id int not null,
    basket_id    int not null,
    count        int not null,
    constraint fk_menu_item_x_basket_basket_id__basket_id foreign key (basket_id) references basket (id),
    constraint fk_menu_item_x_basket_menu_item_id__menu_item_id foreign key (menu_item_id) references menu_item (id)
);

create table "user"
(
    id        int generated always as identity primary key,
    email     varchar(64) not null unique,
    name      varchar(32),
    password  varchar(32) not null,
    lastname  varchar(32),
    address   varchar(64),
    basket_id int         not null,
    city_id   int         not null,
    locale_id int,
    constraint fk_city_id__city_id foreign key (city_id) references city (id),
    constraint fk_locale_id__locale_id foreign key (locale_id) references locale (id),
    constraint fk_basket_id__basket_id foreign key (basket_id) references basket (id) on delete cascade
);

create table "order"
(
    id          int generated always as identity primary key,
    created     timestamp   not null,
    status      varchar(10) not null,
    paid        number(1)   not null,
    user_id     int         not null,
    location_id int         not null,
    constraint fk_order_location_id__location_id foreign key (location_id) references location (id),
    constraint fk_user_id__user_id foreign key (user_id) references "user" (id)
);

create table menu_item_x_order
(
    menu_item_id int not null,
    order_id     int not null,
    quantity     int not null,
    constraint pk_menu_item_x_order primary key (menu_item_id, order_id),
    constraint fk_menu_item_x_order_order_id__order_id foreign key (order_id) references "order" (id),
    constraint fk_menu_item_x_order_menu_item_id__menu_item_id foreign key (menu_item_id) references menu_item (id)
);

create table order_x_locale
(
    order_id  int not null,
    locale_id int not null,
    constraint pk_order_locale primary key (order_id, locale_id),
    constraint fk_locale_id__locale_id_order foreign key (locale_id) references locale (id),
    constraint fk_order_id__order_id foreign key (order_id) references "order" (id)
);

create table role
(
    id   int generated always as identity primary key,
    name varchar(16) not null unique
);

create table user_x_role
(
    user_id int not null,
    role_id int not null,
    constraint pk_user_x_role primary key (user_id, role_id),
    constraint fk_user_x_role_role_id__role_id foreign key (role_id) references role (id),
    constraint fk_user_x_role_user_id__user_id foreign key (user_id) references "user" (id)
);
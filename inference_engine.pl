:- consult('explanation_module.pl').
:- consult('knowledge_base.pl').

% Recommend a product based on user preference
recommend_product(User, Product) :-
    user_preference(User, Category),
    product(Product, Category, _).

% Recommend a newer product
recommend_newer_product(User, Product, Explanation) :-
    user_preference(User, Category),
    product(Product, Category, Year),
    current_year(CurrentYear),
    Year > CurrentYear - 3, % Products released in the last 3 years
    explain_newer_recommendation(User, Product, Explanation).

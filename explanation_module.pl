% Explain why the product is being recommended

explain_recommendation(User, Product, Explanation) :-
    user_preference(User, Category),
    product(Product, Category, _),
    format(atom(Explanation), 'Recommendation for ~w based on your interest in ~w.', [Product, Category]).

explain_newer_recommendation(User, Product, Explanation) :-
    user_preference(User, Category),
    product(Product, Category, Year),
    current_year(CurrentYear),
    Year > CurrentYear - 3, % Products released in the last 3 years
    format(atom(Explanation), 'Recommendation for ~w based on your interest in ~w and recent release.', [Product, Category]).

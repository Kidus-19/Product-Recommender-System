:- dynamic user_preference/2.

add_user_preference(User, Category) :-
    assert(user_preference(User, Category)).

remove_user_preference(User, Category) :-
    retract(user_preference(User, Category)).

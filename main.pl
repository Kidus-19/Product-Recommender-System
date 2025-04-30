% main.pl

:- use_module(library(pce)).
:- use_module(library(pce_style_item)).

% Consult all required files
:- consult('knowledge_base.pl').   % PL facts are stored here
:- consult('inference_engine.pl'). % Recommendation rules
:- consult('knowledge_acquisition.pl'). % To add and remove the data dynamically
:- consult('explanation_module.pl'). % To explain why the product is recommended

start_gui :-
    cleanup_existing_objects,  % Ensure any existing objects are cleaned up
    start_gui_logic.

close_gui :-
    cleanup_existing_objects,
    send(@main, destroy).

% GUI Initialization
start_gui_logic :-
    cleanup_existing_objects,  % Clean up any existing objects to avoid conflicts

    new(@main, dialog('Product Recommender', size(1000, 600))),
    send(@main, append, new(@header, text('Welcome to Product Recommender'))),
    send(@header, font, font(helvetica, bold, 20)),
    send(@header, colour, blue),

    % Username Input Section
    send(@main, append, new(@label_username, label('Enter your username:'))),
    send(@label_username, font, font(helvetica, roman, 14)),
    send(@main, append, new(@username, text_item('Username'))),
    send(@username, colour, black),
    send(@username, width, 20),

    % Buttons with Styles
    send(@main, append, button('Get Recommendation', message(@prolog, get_recommendation))),
    send(@main, append, button('Recommend Newer Product', message(@prolog, recommend_newer_product))),
    send(@main, append, button('Create New User', message(@prolog, create_user))),
    send(@main, append, button('Remove User', message(@prolog, remove_user))),
    send(@main, append, button('Quit', message(@main, destroy))),

    % Recommendation and Explanation Display
    send(@main, append, new(@recommendation, text_item('Recommendation:'))),
    send(@recommendation, font, font(helvetica, bold, 12)),
    send(@recommendation, colour, dark_green),
    send(@recommendation, width, 50),
    send(@main, append, new(@recommendation_comment, text_item('Explanation:'))),
    send(@recommendation_comment, font, font(helvetica, italic, 12)),
    send(@recommendation_comment, colour, dark_red),
    send(@recommendation_comment, width, 100),

    % Background and Window Settings
    send(@main, background, light_grey),
    send(@main, open_centered).

% Button click event handler
get_recommendation :-
    get(@username, selection, Username),
    get_product_recommendation(Username, Recommendation, Explanation),
    send(@recommendation, selection, Recommendation),
    send(@recommendation_comment, selection, Explanation).

% Predicate to get a product recommendation for a user
get_product_recommendation(User, Recommendation, Explanation) :-
    recommend_product(User, Recommendation),
    explain_recommendation(User, Recommendation, Explanation).

% Button click event handler for recommending newer products
recommend_newer_product :-
    get(@username, selection, Username),
    recommend_newer_product(Username, Recommendation, Explanation),
    send(@recommendation, selection, Recommendation),
    send(@recommendation_comment, selection, Explanation).

% Predicate to create a new user
create_user :-
    cleanup_dialog(@create_user_dialog),  % Ensure no existing dialog interferes
    cleanup_dialog(@create_user_label_username), % Clean up existing label if it exists
    cleanup_dialog(@new_username), % Clean up existing text item if it exists
    cleanup_dialog(@create_user_label_category), % Clean up existing label if it exists
    cleanup_dialog(@new_category), % Clean up existing text item if it exists

    new(@create_user_dialog, dialog('Create New User', size(400, 200))),
    send(@create_user_dialog, background, light_blue),
    send(@create_user_dialog, append, new(@create_user_label_username, label('Enter new username:'))),
    send(@create_user_label_username, font, font(helvetica, roman, 12)),
    send(@create_user_dialog, append, new(@new_username, text_item('Username:'))),
    send(@create_user_dialog, append, new(@create_user_label_category, label('Enter preferred category:'))),
    send(@create_user_label_category, font, font(helvetica, roman, 12)),
    send(@create_user_dialog, append, new(@new_category, text_item('Category:'))),
    send(@create_user_dialog, append, button('Create User', message(@prolog, add_new_user))),
    send(@create_user_dialog, append, button('Cancel', message(@create_user_dialog, destroy))),
    send(@create_user_dialog, open_centered).

% Predicate to add a new user
add_new_user :-
    get(@new_username, selection, NewUsername),
    get(@new_category, selection, NewCategory),
    add_user_preference(NewUsername, NewCategory),
    send(@create_user_dialog, destroy).

% Predicate to remove a user
remove_user :-
    cleanup_dialog(@remove_user_dialog),  % Ensure no existing dialog interferes
    cleanup_dialog(@remove_user_label_username), % Clean up existing label if it exists
    cleanup_dialog(@remove_username), % Clean up existing text item if it exists

    new(@remove_user_dialog, dialog('Remove User', size(400, 150))),
    send(@remove_user_dialog, background, salmon),  % Use a recognized color name
    send(@remove_user_dialog, append, new(@remove_user_label_username, label('Enter username to remove:'))),
    send(@remove_user_label_username, font, font(helvetica, roman, 12)),
    send(@remove_user_dialog, append, new(@remove_username, text_item('Username:'))),
    send(@remove_user_dialog, append, button('Remove User', message(@prolog, remove_existing_user))),
    send(@remove_user_dialog, append, button('Cancel', message(@remove_user_dialog, destroy))),
    send(@remove_user_dialog, open_centered).

% Predicate to remove an existing user
remove_existing_user :-
    get(@remove_username, selection, RemoveUsername),
    remove_user_preference(RemoveUsername, _),
    send(@remove_user_dialog, destroy).

% Clean up existing objects to avoid conflicts
cleanup_existing_objects :-
    cleanup_dialog(@main),
    cleanup_dialog(@header),
    cleanup_dialog(@recommendation),
    cleanup_dialog(@recommendation_comment),
    cleanup_dialog(@username).

% Clean up specific dialog if it exists
cleanup_dialog(Dialog) :-
    (   object(Dialog)
    ->  send(Dialog, destroy)
    ;   true).

% Helper predicate to provide current year
current_year(2024).

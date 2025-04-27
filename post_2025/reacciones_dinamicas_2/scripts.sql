BEGIN
    -- DELETE FROM apex_user_reactions;
    -- DELETE FROM apex_reactions;

    -- Insertar reacciones predefinidas con iconos APEX
    INSERT INTO apex_reactions (reaction_code, reaction_title, icon_name, display_order)
    VALUES ('like', 'Like', 'fa-thumbs-up', 1);

    INSERT INTO apex_reactions (reaction_code, reaction_title, icon_name, display_order)
    VALUES ('celebrate', 'Celebrate', 'fa-trophy', 2);

    INSERT INTO apex_reactions (reaction_code, reaction_title, icon_name, display_order)
    VALUES ('support', 'Support', 'fa-heart', 3);

    INSERT INTO apex_reactions (reaction_code, reaction_title, icon_name, display_order)
    VALUES ('love', 'Love', 'fa-star', 4);

    INSERT INTO apex_reactions (reaction_code, reaction_title, icon_name, display_order)
    VALUES ('insightful', 'Insightful', 'fa-lightbulb-o', 5);

    INSERT INTO apex_reactions (reaction_code, reaction_title, icon_name, display_order)
    VALUES ('curious', 'Curious', 'fa-question-circle', 6);

    COMMIT;
END;
/
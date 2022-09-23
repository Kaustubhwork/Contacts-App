-module(entries).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

 main() -> 
     #template{ file="./site/templates/bare.html"}.


body()->



            Var = helper:parse_file("Contacts.csv"),
            
            Header = #tablerow
            {
            cells = [
                       #h1{text="Information"},
                       #tableheader { text=" Name :" },
                       #tableheader { text=" Phone number :" },
                       #tableheader { text=" Address : " },
                       #tableheader { text=" Gender : " },
                       #tableheader { text=" Date of birth  :" },
                       #tableheader { text="  Option :" }
                    
                    ]
            },
            % List = #tablecell{body = #button{text ="Delete"}},           
            Rows = lists:map(fun (Row) ->
                            
                            Cells = lists:map(fun (Val) ->
                            #tablecell{text=Val} end,Row) ++ [#tablecell{body = #button{
                            id=click,
                            class="btn btn-success",
                            handle_invalid = true,
                            on_invalid=#alert{text="Deleted"},
                            postback = delete,
                            text ="Delete"}}],        
                    #tablerow{cells=Cells}
                    end,Var),
        #table {class ="table table-bordered border-primary",header = Header, rows=Rows}.

event_invalid(delete) ->
wf:flash("A server-side validator returned false").

event(delete)->    
    Message = wf:f("Deleted"),
    wf:flash(Message),
    ok;
event(_)->
    ok.
%-----------------------------------------------------
event({delete,Row})->
    Var = helper:parse_file("Contacts.csv"),

    A = lists:delete(Row,Var),
    [[Name,Phoneno,Address,Gender,Dob]] = A,
    % X =string:join()
    A ="kc"
    % X = io:format("~p,~p,~p,~p,~p~n",[Name,Phoneno,Address,Gender,Dob]),
    D = file:write_file("Contacts.csv", X  ,[write]),   
    io:format("~p~n",[X]).

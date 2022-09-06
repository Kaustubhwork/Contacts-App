-module(mypage).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html"}.


middle() ->
    #container_12 { body=[
        #grid_8 { alpha=true, prefix=2, suffix=2, omega=true,body=inner_body() }
    ]}.

%----------------------------------------------------------------------------------
inner_body() ->
%        Var = "graph TB\n Client --> Server",
        
        Body = [
        %Var = "graph TB\n Client -- Server",
        
            %#h2{text = "Data Flowdiagram"},
            % #label{text="Contacts's dataflow : "},
            % #mermaid{code=Var},
            % #br{},

            #flash{},        
            #h1 { text="Contact information" },
%----------------------------------------------------------------------

           #label { text="Name" },
           #textbox { id=nameTextBox},

           
           #label { text="Enter Your Phoneno:" },
           #textbox { id=numberTextBox},
           
           
           #label { text="Enter Your Address:" },
           #textarea { text="",id=box },
           % #textbox { id=box},
           
           #label {text="Enter Your Gender:"},
            #dropdown{id=gender,options=[
            #option{value="",text="Please select"},
            % #textbox{id= gender},
            #option{value=male,text="Male"},
            #option{value=female,text="Female"}
            ]},

           
           #label { text="Enter Your Date of birth:" },
           #textbox{id=dob},

            #p{},
            #button {
            id=continueButton,
            text="Continue",
            handle_invalid=true,
            on_invalid=#alert{text="At least one validator failed client-side (meaning it didn't need to try the server)"},
            postback=continue
        }
        ],
        
   wf:wire(continueButton,nameTextBox, #validate { validators=[
        #is_required { text="Required." }
    ]}),


   wf:wire(continueButton,numberTextBox,#validate{ validators =[
        #is_required{text="Required."},
        #is_integer { text="Enter a valid Phone number."}
    ]}),

   wf:wire(continueButton, box, #validate { validators=[
        #is_required { text="Required." }
    ]}),

    wf:wire(continueButton, gender, #validate { validators=[
        #is_required { text="Required." }
    ]}),

    wf:wire(continueButton,dob,#validate{ validators =[
        % calendar:now_to_local_time(),
        % valid_date(dob),
        #is_required{text="Required"},
        #is_integer { text="Enter Valid Date of birth."}
        ]}),
    Body.

% validd_date()->
% dob=calender:now_to_local_time().


%2() function call after event call "Continue"
%-------------------------------------------------
event_invalid(continue) ->
wf:flash("A server-side validator returned false").

%() function call after event call "Continue"
%------------------------------------------------
event(continue) ->
    Name = wf:q(nameTextBox),
    Phoneno = wf:q(numberTextBox),
    Address =wf:q(box),
    Gender=wf:q(gender),
    % Dob=calender:valid_date(),
    Dob=wf:q(dob),
    start(Name,Phoneno,Address,Gender,Dob),
    Message = wf:f("Welcome ~s! Your information is valid.", [Name]),
    wf:flash(Message),
    ok;

event(_) -> ok.
%--------------------------------------------------------------------------------------------
%string:to_str()

    % Data2 = string:join(["Name = ","Phoneno = "," Address = "," Gender = ","Dob = "],Data),
    % Data = Name ++ "\n" ++ Phoneno ++ "\n"  ++ Address ++"\n" ++ Gender ++ "\n" ++ Dob,

start(Name,Phoneno,Address,Gender,Dob)->
 
    Data = string:join([Name,Phoneno,Address,Gender,Dob]," ,"),

    ok =  file:write_file("Contacts.csv",Data ++ "\n",  [append]).

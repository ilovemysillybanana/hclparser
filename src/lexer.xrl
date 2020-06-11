Definitions.

Whitespace = [\s\t]
Terminator = \n|\r\n|\r
Comment    = \#.*|\/\/.*
Comma      = ,
Equal      = =

OpenArray  = \[
CloseArray = \]
OpenCurly  = \{
CloseCurly = \}

Number     = [0-9]
Bool       = true|false
String     = "([^\"\\]|\\.)*"

Identifier = [a-zA-Z_][a-zA-Z0-9_\-\.]*

Rules.
{Whitespace}     : skip_token.
{Terminator}     : skip_token.
{Comment}        : skip_token.
{Comma}          : {token, {comma, TokenLine, list_to_atom(TokenChars)}}.
{OpenArray}      : {token, {open_array, TokenLine, list_to_atom(TokenChars)}}.
{CloseArray}     : {token, {close_array, TokenLine, list_to_atom(TokenChars)}}.
{OpenCurly}      : {token, {open_curly, TokenLine, list_to_atom(TokenChars)}}.
{CloseCurly}     : {token, {close_curly, TokenLine, list_to_atom(TokenChars)}}.
{Equal}          : {token, {equal, TokenLine, list_to_atom(TokenChars)}}.

% Data Types 
{Number}                                      : {token, {number, TokenLine, list_to_integer(TokenChars)}}.
{Number}+\.{Number}+((E|e)(\+|\-)?{Number}+)? : {token, {float, TokenLine,list_to_float(TokenChars)}}.
{Bool}                                        : {token, {bool, TokenLine, list_to_atom(TokenChars)}}.
{String}                                      : {token, {string, TokenLine, list_to_binary(string:trim(TokenChars, both, "\""))}}.

% Terraform has identifiers in the name of "resources", "variables", "providers", etc
{Identifier} : {token, {identifier, TokenLine, list_to_binary(string:trim(TokenChars, both, "\""))}}.

Erlang code.
xquery version "3.1";

import schema default element namespace "" at "Superheroes08.xsd";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202021.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: Olyan hősök, ahol az occupation része a criminal, de az alignment good :)
declare function local:tokenize-occupations($occupation as xs:string) {
    let $occupation-tokens := $occupation => tokenize("[,;]+")
    for $token in $occupation-tokens
        return $token => fn:replace("\([^()]*\)", "") => fn:normalize-space()
};

declare function local:criminal-occupations($occupation as xs:string) {
    local:tokenize-occupations($occupation) => fn:filter(
        function($o) { fn:contains($o, "criminal") }
    )
};

validate {<former-criminals>
{for $superhero in $superheroes?*
    let $criminal-occupations := local:criminal-occupations($superhero?work?occupation)
    return if ($superhero?biography?alignment ne "good" or fn:empty($criminal-occupations))
    then ()
    else (
        <former-criminal>
            {element { "name" } { $superhero?name }}
            {for $criminal-occupation in $criminal-occupations
                return element { "criminal-occupation" } { $criminal-occupation }}
        </former-criminal>
    )
}
</former-criminals>
}

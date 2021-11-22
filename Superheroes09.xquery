xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202010.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: Olyan hősök, akik rokonai valamelyik másik hősnek :)
declare function local:tokenize-relatives($relatives as xs:string) {
    let $relatives-tokens := $relatives => tokenize("\),|\);")
    for $token in $relatives-tokens
        return $token => fn:replace("\((.*)", "") => fn:normalize-space()
};

declare function local:get-relatives($superhero) {
    let $relatives := local:tokenize-relatives($superhero?connections?relatives)
    for $relative in $relatives
        let $relative-name := fn:replace($relative, "\([^()]*\)", "") => fn:normalize-space()
        return $superheroes?*[?name = $relative-name]
};

<superheroes-with-superhero-relatives>
{for $superhero in $superheroes?*
    let $related-heroes := local:get-relatives($superhero)
    return if (fn:empty($related-heroes))
    then ()
    else (
        <superhero>
            {element { "name" } { $superhero?name },
            for $related-hero in $related-heroes
                return element { "relative" } { $related-hero?name }}
        </superhero>
    )
}
</superheroes-with-superhero-relatives>

xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:escape-uri-attributes "no";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202021.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: Szuperhősök száma fajonként, JSON asszociatív tömb formátumba sorolva :)
let $races := $superheroes?*?appearance?race => distinct-values()

return array {
for $race in $races
    order by $race
    let $heroes-in-race := $superheroes?*[?appearance?race = $race]
    let $num-heroes-in-race := $heroes-in-race => count()
    let $heroes-names-in-race := $heroes-in-race?name
    return map {
        "race": $race,
        "numberOfSuperheroes": $num-heroes-in-race,
        "superheroes": array { $heroes-names-in-race }
    }
}

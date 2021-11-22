xquery version "3.1";

import schema default element namespace "" at "Superheroes07.xsd";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202021.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: Jó hősök aránya fajonként, csökkenő sorrendben :)
let $races := $superheroes?*?appearance?race => distinct-values()

return
<races>
{for $race in $races
    let $heroes-in-race := $superheroes?*[?appearance?race = $race]
    let $num-heroes-in-race := $heroes-in-race => count()
    let $num-good-heroes-in-race := $heroes-in-race[?biography?alignment = "good"] => count()
    let $good-ratio := fn:round($num-good-heroes-in-race div $num-heroes-in-race, 3)
    order by $good-ratio descending, $race
    return element { "race" } {
        attribute { "name" } { $race },
        attribute { "good-ratio" } { $good-ratio }
    }
}
</races>

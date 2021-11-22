xquery version "3.1";

import schema default element namespace "" at "Superheroes01.xsd";
declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202021.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: A legintelligensebb szuperhős :)

let $max-int := $superheroes?*?powerstats?intelligence => max()

return validate {
<superheroes>
    {for $name in $superheroes?*[?powerstats?intelligence = $max-int]?name
    order by $name
    return <superhero>{$name}</superhero>}
</superheroes>
}

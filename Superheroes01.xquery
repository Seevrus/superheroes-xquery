xquery version "3.1";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202010.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: A legintelligensebb szuperhős :)

let $max-int := $superheroes?*?powerstats?intelligence => max()

return
<names>
    {for $name in $superheroes?*[?powerstats?intelligence = $max-int]?name
    order by $name
    return <name>{$name}</name>}
</names>

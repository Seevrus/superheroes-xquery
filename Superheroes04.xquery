xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202010.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: A legerősebb szuperhős (powerstat átlag) :)

declare function local:average-powerstats($powerstats as map(xs:string, xs:double)) {
    let $avg-stat := map:for-each(
            $powerstats,
            function($key, $value) { $value }
        ) => avg()
    return fn:round($avg-stat, 2)
};

let $heroes-avg-stats := map:merge(
    for $superhero in $superheroes?*
        let $avg-stat := local:average-powerstats($superhero?powerstats)
        return map:entry($superhero?name, $avg-stat)
)

let $max-avg-stat := map:for-each(
    $heroes-avg-stats,
    function($key, $value) { $value }
) => max()

return
<superheroes>
{for $superhero in $superheroes?*
    order by $superhero?name
    let $hero-avg-stat := map:get($heroes-avg-stats, $superhero?name)
    return if ($hero-avg-stat = $max-avg-stat) 
    then element { "superhero" } {
        attribute { "name" } { $superhero?name },
        attribute { "avg-stat" } { $hero-avg-stat }
    }
    else ()
}
</superheroes>

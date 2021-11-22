xquery version "3.1";

import schema default element namespace "" at "Superheroes02.xsd";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202021.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: Az a szuperhős, akinek egy tulajdonsága a legkisebb. Melyik ez a tulajdonság? :)
let $stats := $superheroes?1?powerstats => map:keys()

return validate {
<stats>
    <min-stats>
        {for $stat in $stats
            let $min-stat := $superheroes?*?powerstats?($stat) => min()
            let $min-names := $superheroes?*[?powerstats?($stat) = $min-stat]?name
            return element { $stat } {
                for $min-name in $min-names
                    return element superhero {
                        attribute { "name" } { $min-name },
                        attribute { "stat" } { $min-stat }
                    }
            }
         }
    </min-stats>
    <max-stats>
        {for $stat in $stats
            let $max-stat := $superheroes?*?powerstats?($stat) => max()
            let $max-names := $superheroes?*[?powerstats?($stat) = $max-stat]?name
            return element { $stat } {
                for $max-name in $max-names
                    return element superhero {
                        attribute { "name" } { $max-name },
                        attribute { "stat" } { $max-stat }
                    }
            }
         }
    </max-stats>
</stats>
}

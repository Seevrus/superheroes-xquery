xquery version "3.1";

import schema default element namespace "" at "Superheroes05.xsd";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202021.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: Férfi szuperhősök átlagos magassága és testsúlya :)

declare function local:get-average-value($heroes, $appearance-key as xs:string) {
    let $values := for $v in $heroes?appearance?($appearance-key)?2
        let $value := xs:double(fn:replace(fn:head(tokenize($v, ' ')), ',', ''))
        let $unit := fn:tail(tokenize($v, ' '))
        return if ($value = 0) then () else (
            switch ($unit)
                case "meters" return $value*100
                case "tons" return $value*1000
                default return $value
        )
    return fn:round($values => avg(), 2)
};

let $male-heroes := $superheroes?*[?appearance?gender = "Male"]

(: Vannak kiugró értékek, pl. Godzilla 90000 tonnát nyom :)
return
<male-heroes>
    <avg-height>{local:get-average-value($male-heroes, "height")} cm</avg-height>
    <avg-weight>{local:get-average-value($male-heroes, "weight")} kg</avg-weight>
</male-heroes>

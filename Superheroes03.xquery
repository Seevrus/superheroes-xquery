xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202010.json";
declare variable $superheroes := json-doc($superheroes-uri);

(: Melyik kiadó adta ki a legtöbb / legkevesebb szuperhőst? :)
let $publishers := $superheroes?*?biography?publisher[. != ""] => distinct-values()
let $num-heroes-by-publisher := map:merge(
    for $publisher in $publishers
        return map:entry($publisher, $superheroes?*[?biography?publisher = $publisher] => count())
)

return
<publishers>
{for $publisher in $publishers
    let $superheroes := map:get($num-heroes-by-publisher, $publisher)
    order by $superheroes descending
    return element publisher {
        attribute { "name" } { $publisher },
        attribute { "superheroes" } { $superheroes }
    }
}
</publishers>

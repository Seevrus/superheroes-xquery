xquery version "3.1";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html";
declare option output:html-version "5.0";
declare option output:indent "yes";

declare variable $superheroes-uri as xs:string external := "superhero-api-all-11202010.json";
declare variable $superheroes := json-doc($superheroes-uri);

declare function local:affiliation($superhero) {
    $superhero?connections?groupAffiliation => tokenize("[,;]+") => fn:head()
};

(: HTML táblázat a szuperhősök főbb adataival :)
document {
<html>
    <head>
        <title>Summary of Superheroes</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" />
        <script src="Superheroes10.js" />
    </head>
    <body>
        <div class="container-md">
            <table class="table table-bordered table-hover caption-top">
                <caption>Superheroes</caption>
                <thead>
                    <tr>
                        <th onClick="quickSortTable(0)">#</th>
                        <th onClick="quickSortTable(1)">Name</th>
                        <th onClick="quickSortTable(2)">Full Name</th>
                        <th onClick="quickSortTable(3)">Race</th>
                        <th onClick="quickSortTable(4)">Alignment</th>
                        <th onClick="quickSortTable(5)">Affiliation</th>
                        <th onClick="quickSortTable(6)">Publisher</th>
                    </tr>
                </thead>
                <tbody id="heroes">
                {for $superhero in $superheroes?*
                    return
                    <tr>
                        <td>{$superhero?id}</td>
                        <td>{$superhero?name}</td>
                        <td>{$superhero?biography?fullName}</td>
                        <td>{$superhero?appearance?race}</td>
                        <td>{$superhero?biography?alignment}</td>
                        <td>{local:affiliation($superhero)}</td>
                        <td>{$superhero?biography?publisher}</td>
                    </tr>
                }
                </tbody>
            </table>
        </div>
    </body>
</html>
}

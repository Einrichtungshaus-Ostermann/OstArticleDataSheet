
{* our namespace *}
{namespace name="frontend/ost-article-data-sheet/data-sheet"}

<html>
<head>
<style type="text/css">
    body {
        font-size:10px;
        font-family:Verdana;
    }

    h1 {
        font-size:14px;
        font-weight:bold;
    }

    #logo {
        padding-top: 20px;
        padding-bottom: 40px;
        text-align:center;
    }

    #content {
        width: 750px;
        height: 1080px;
        margin-left: 20px;
    }

    #price {
        font-weight: bold;
        font-size:160%;
    }

    #description {
        margin-top: 10px;
    }

    table {
        font-size:10px;
        font-family:Verdana;
    }

    table#article-data {
        width: 600px;
    }

    table#article-data td.article-data-td {
        width: 300px;
    }

    table#article-data td.image {
        vertical-align: top;
    }

    .border-line {
        vertical-align: top;
        border: 1px solid #C7C7C7;
    }

    .image-thumbnail {
        max-width: 100px;
        max-height: 100px;
    }

</style>
</head>
<body>
<div id="content">
    <div id="logo"><img src="https://www.ostermann.de/media/image/header-logo57a1f3925e36a.jpg"></div>
    <h1>{$product->getName()}</h1>
    <table id="article-data" cellspacing="10">
        <tbody>
        <tr>
            <td class="article-data-td image">
                {if is_object($product->getCover())}<img src="{$product->getCover()->getFile()}" style="max-height:250px; max-width: 250px;">{/if}
            </td>
            <td class="article-data-td">
                <div id="price">
                    {$product->getCheapestPrice()->getCalculatedPrice()|currency}
                </div>
                <br>
                {s name="supplier"}Marke:{/s} {$product->getManufacturer()->getName()}
                <br>
                {s name="article-number"}Artikelnummer:{/s} {$product->getNumber()}
            </td>
        </tr>
        </tbody>
    </table>
    <div>
        {foreach $product->getMedia() as $key => $media}
            {if $key == 0}
                {continue}
            {/if}
            <img src="{$media->getThumbnail(0)->getSource()}" alt="" style="margin:0 5px 5px 0;" class="image-thumbnail"/>
        {/foreach}
    </div>
    <div id="description">
        {if $product->getShortDescription() != ""}
            {$product->getShortDescription()}
            <br/>
        {/if}
        {if $product->getLongDescription() != ""}
            {$product->getLongDescription()|replace:"../":""|replace:"</p><li>":"</p><br />- "|replace:"<li>":"- "|replace:"</li>":"<br />"}
            <br/>
        {/if}
        {if is_object($product->getPropertySet()) && count($product->getPropertySet()->getGroups()) > 0}
            <b>{s name="properties"}Artikeleigenschaften{/s}</b>
            <table cellspacing="0">
                {foreach $product->getPropertySet()->getGroups() as $group}
                    <tr>
                        <td width="150px">{$group->getName()}:</td>
                        {assign var="options" value=$group->getOptions()}
                        <td>{$options[0]->getName()}</td>
                    </tr>
                {/foreach}
            </table>
            <br/>
        {/if}
    </div>
</div>
</body>
</html>
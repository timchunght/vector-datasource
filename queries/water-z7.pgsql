SELECT name, area, kind, source, __geometry__, __id__

FROM
(
    --
    -- Ocean
    --
    SELECT
        '' AS name,
        sum(way_area)::bigint AS area,
        'ocean' AS kind,
        'naturalearthdata.com' AS source,
        st_union(the_geom) AS __geometry__,
        max(gid) __id__

    FROM ne_10m_ocean

    WHERE the_geom && !bbox!

    --
    -- Lakes
    --
    UNION

    SELECT
        name,
        sum(way_area)::bigint AS area,
        'lake' AS kind,
        'naturalearthdata.com' AS source,
        st_union(the_geom) AS __geometry__,
        max(gid) __id__

    FROM ne_10m_lakes

    WHERE the_geom && !bbox!
    GROUP BY name

    --
    -- Playas
    --
    UNION

    SELECT
        name,
        sum(way_area)::bigint AS area,
        'playa' AS kind,
        'naturalearthdata.com' AS source,
        st_union(the_geom) AS __geometry__,
        max(gid) __id__

    FROM ne_10m_playas

    WHERE the_geom && !bbox!
    GROUP BY name

) AS water_areas

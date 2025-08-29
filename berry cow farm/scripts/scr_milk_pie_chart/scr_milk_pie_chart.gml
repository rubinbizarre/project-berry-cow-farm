/// @func draw_pie_slice(cx, cy, r1, r2, angle1, angle2, col)
/// @desc Draws a donut-style slice (between inner radius r1 and outer radius r2)
/// cx,cy = center, r1 = inner radius, r2 = outer radius, 
/// angle1/angle2 in degrees, col = color

function draw_pie_slice(cx, cy, r1, r2, angle1, angle2, col)
{
    var steps = max(6, (angle2 - angle1) div 4); // more steps = smoother
    var angle_step = (angle2 - angle1) / steps;

    draw_primitive_begin(pr_trianglestrip);
    draw_set_color(col);

    for (var i = 0; i <= steps; i++)
    {
        var a = angle1 + i * angle_step;
		var cos_a = dcos(a);
		var sin_a = -dsin(a);

        // outer point
        draw_vertex(cx + cos_a * r2, cy + sin_a * r2);
        // inner point
        draw_vertex(cx + cos_a * r1, cy + sin_a * r1);
    }

    draw_primitive_end();
}

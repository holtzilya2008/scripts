import svgwrite
import math

def create_cells_svg(num_cells, filename):
    # Determine the number of rows and columns to make the grid as square as possible
    cols = int(math.sqrt(num_cells))
    rows = math.ceil(num_cells / cols)

    # Set the size of each cell and the spacing between them
    cell_size = 20
    spacing = 2

    # Calculate the width and height of the SVG
    width = (cell_size + spacing) * cols
    height = (cell_size + spacing) * rows

    # Create the SVG file
    dwg = svgwrite.Drawing(filename, size=(width, height), profile='tiny')

    # Draw a white background rectangle
    dwg.add(dwg.rect(insert=(0, 0), size=(width, height), fill='grey'))

    # Draw the cells
    for row in range(rows):
        for col in range(cols):
            x = col * (cell_size + spacing)
            y = row * (cell_size + spacing)

            dwg.add(dwg.rect(insert=(x, y), size=(cell_size, cell_size), fill='black'))

    # Save the SVG file
    dwg.save()

create_cells_svg(2000, 'cells_notebook.svg')

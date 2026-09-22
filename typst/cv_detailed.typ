// Detailed, full-width variant of the CV.
// Developed in parallel to cv.typ; data lives in configuration_detailed.yml.

#let configuration = yaml("configuration_detailed.yml")
#let settings = yaml("settings.yml")
#let person = configuration.personal

#let heading_font = "Poppins"

#set page(margin: (x: 18mm, y: 16mm))
#set text(size: eval(settings.font.size.body))
#set par(leading: eval(settings.paragraph.leading), justify: false)

// Section heading: uppercase title followed by a rule spanning the page.
#show heading.where(level: 1): it => {
  v(0.6em)
  block(below: 0.5em)[
    #set text(size: eval(settings.font.size.heading), font: heading_font, weight: "semibold")
    #grid(
      columns: (auto, 1fr),
      column-gutter: 0.6em,
      align: horizon,
      upper(it.body),
      line(length: 100%, stroke: 0.6pt),
    )
  ]
}

#let maybe_link(name, url) = if url != "" { link(url)[#name] } else { name }

// One entry: bold left title, right-aligned date range, subtitle line, bullets.
// Spacing inside an entry is kept tight so that the gap between entries reads larger.
#let entry(title, subtitle: none, subtitle_right: none, dates: none, extra: none, points: (), indent: 0em, bold_subtitle: false) = {
  block(below: 1.2em, inset: (left: indent))[
    #block(below: 0.25em)[
      #grid(
        columns: (1fr, auto),
        column-gutter: 1em,
        [#set text(size: 11pt); *#title*],
        [#set text(size: 10pt, style: "italic"); #dates],
      )
    ]
    #if subtitle != none [
      #block(below: if points.len() > 0 or extra != none { 0.35em } else { 0em })[
        #set text(size: 10pt, style: if bold_subtitle { "normal" } else { "italic" })
        #grid(
          columns: (1fr, auto),
          column-gutter: 1em,
          if bold_subtitle [*#subtitle*] else [#subtitle],
          if subtitle_right != none { if bold_subtitle [*#subtitle_right*] else [#subtitle_right] },
        )
      ]
    ]
    #if extra != none [
      #block(below: if points.len() > 0 { 0.35em } else { 0em })[#extra]
    ]
    #if points.len() > 0 [
      #set text(size: eval(settings.font.size.body))
      #block(below: 0em)[
        #list(indent: 0.4em, body-indent: 0.5em, spacing: 0.45em, ..points)
      ]
    ]
  ]
}

// Selected coursework, laid out in two columns.
#let coursework_grid(courses) = {
  set text(size: eval(settings.font.size.body))
  pad(left: 1.2em, grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    row-gutter: 0.35em,
    ..courses,
  ))
}

// Bold degree line with the GPA right-aligned, as in the reference resume.
#let degree_row(degree, gpa) = block(below: 0.35em)[
  #set text(size: 10pt)
  #grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    [*#degree*],
    if gpa != "" [*GPA #gpa*],
  )
]

#let daterange(from, to) = if to == "" { from } else { from + " — " + to }

// ---------------------------------------------------------------- header
#grid(
  columns: (1fr, auto),
  column-gutter: 1em,
  align: horizon,
  [
    #set text(font: heading_font)
    #[
      #set text(size: 24pt, weight: "medium")
      #upper[*#person.name*]
    ] \
    #v(0.2em)
    #[
      #set text(size: 10pt)
      #link("mailto:" + person.email)[#person.email] \
      #link("tel:" + person.phone.replace(" ", ""))[#person.phone] \
      #link(person.github_link)[#person.github]
    ]
  ],
  block(clip: true, radius: 2mm, width: 28mm, height: 34mm)[
    #image(person.headshot, width: 100%, height: 100%, fit: "cover")
  ],
)

= Education

#block(below: 1em, inset: (left: 0.8em))[
  #set text(size: 10pt, style: "italic")
  #configuration.education_intro
]

#for place in configuration.education {
  entry(
    maybe_link(place.institution, place.link),
    subtitle: place.location,
    extra: degree_row(place.degree, place.gpa)
      + if place.coursework.len() > 0 { coursework_grid(place.coursework) } else { [] },
    indent: 0.8em,
    dates: daterange(place.from, place.to),
    points: place.points,
  )
}

= Experience

#for org in configuration.organizations {
  entry(
    org.position + ", " + maybe_link(org.organization, org.link),
    subtitle: org.location,
    dates: daterange(org.from, org.to),
    points: org.points,
  )
}

#for job in configuration.experience {
  entry(
    job.position + " at " + maybe_link(job.organization, job.link),
    subtitle: job.location,
    dates: daterange(job.from, job.to),
    points: job.points,
  )
}

= Projects

#for project in configuration.projects {
  entry(
    project.name
      + if project.link != "" [ #text(size: 8pt)[#link(project.link)[(github)]]]
      else if project.link_note != "" [ #text(size: 8pt)[(#project.link_note)]],
    subtitle: project.course + if project.note != "" { " — " + project.note } else { "" },
    points: project.points,
  )
}

= Skills

#{
  set text(size: 11pt)
  [*Languages:* ] + configuration.skills.languages.join("  •  ")
  linebreak()
  [*Technologies:* ] + configuration.skills.technologies.join("  •  ")
  linebreak()
  [*Interests:* ] + configuration.interests.join("  •  ")
}

#let configuration = yaml("configuration.yml")
#let settings = yaml("settings.yml")

#let heading_font = "Poppins"

#set page(margin: 20mm)

#show heading.where(level: 1): it => [
  #set text(size: eval(settings.font.size.heading), font: heading_font, weight: "semibold")
  #it
  #v(0.2em)
]


#set text(size: eval(settings.font.size.body))

#let sidebarSection = {
  [

    /* Head-shot */
    #[
      #figure(
        block(clip: true, width: 100%, height: 48mm)[
          #scale(
            130%,
            origin: center + horizon,
            move(dy: 2mm, image("images/headshot.jpeg", width: 100%, height: 48mm, fit: "cover")),
          )
        ],
        placement: top,
      )
    ]

    #set text(size: eval(settings.font.size.sidebar))
    #par(
      [
        Honesty in teamwork is most important to me.
        I am passionate about robot learning, hardware involved projects, autonomous systems and numerical methods.
        Physical exercise and a work-life balance feel essential for great
        productivity. I dedicate my free time to being in nature and practising Tricking/Gymnastics.
      ],
      justify: true,
    )
    #[
      *Email:* #link("mailto:trgabl@student.ethz.ch")[trgabl\@student.ethz.ch] \
      *Phone:* #link("tel:+41765756457")[+41 76 575 64 57] \
      *GitHub:* #link("https://github.com/TristanGabl")[TristanGabl] \
    ]
    #v(0.3em)
    #[
      *Notable projects:* \
      #for project in configuration.project_links [
        #if project.link != "" [
          -- #emph[#link(project.link)[#project.name]] \
        ] else [
          -- #emph[#project.name] \
        ]
      ]
    ]

  ]
}

#let mainSection = {
  [

    #upper[
      #set text(font: heading_font)
      #[
        #set text(size: 20pt, weight: "medium")
        *Tristan Gabl* \
      ]
      #[
        #set text(size: 10pt)
        #link("mailto:trgabl@student.ethz.ch")[trgabl\@student.ethz.ch]
      ]
    ]

    = Education

    #{
      for place in configuration.education [
        - #[
            #set text(size: 11pt)
            #[
              #if place.university.link != "" [#link(place.university.link)[*#place.university.name*]] else [*#place.university.name*]
            ]
            #if place.degree != "" [ — #place.degree]
            #if place.major != "" [ #place.major] \
            #place.from #if place.to != "_" [— #place.to] #if place.location != "" [, #place.location] \
            #if place.description != "" [
              #par[
                #set text(size: eval(settings.font.size.body))
                #place.description
              ]
            ]
          ]
          #v(0.6em)
      ]
    }

    = Experience

    #{
      for job in configuration.jobs [
        - #[
            #set text(size: 11pt)
            *#job.position*,
            #if job.company.link != "" [#link(job.company.link)[#job.company.name]] else [#job.company.name] \
            #job.from #if job.to != "_" [— #job.to] #if job.location != "" [, #job.location] \
            #[
              #par[
                #set text(size: eval(settings.font.size.body))
                #job.description
              ]
            ]
          ]
        #v(0.6em)
      ]
    }

    = Skills

    #{
      set text(size: 11pt)
      configuration.skills.languages.join("  •  ")
    }
    #v(0.4em)
    #{
      set text(size: 11pt)
      configuration.skills.technologies.join("  •  ")
    }
  ]
}

#{
  grid(
    columns: (1.618fr, 1fr),
    column-gutter: 1em,
    mainSection, sidebarSection,
  )
}

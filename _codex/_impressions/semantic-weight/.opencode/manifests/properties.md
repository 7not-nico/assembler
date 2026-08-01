---
types:
  fundamentals:
    fields:
      - name: id
        type: string
        required: true
      - name: title
        type: string
        required: true
      - name: summary
        type: string
        required: false
      - name: source
        type: string
        required: false
      - name: key_idea
        type: string
        required: false
      - name: tags
        type: array
        required: false
        own-table: true
  sources:
    fields:
      - name: id
        type: string
        required: true
      - name: title
        type: string
        required: true
      - name: author
        type: string
        required: false
      - name: region_id
        type: string
        required: true
      - name: country
        type: string
        required: false
      - name: institution
        type: string
        required: false
      - name: key_content
        type: string
        required: false
      - name: methodology
        type: string
        required: false
      - name: language
        type: string
        required: false
      - name: doi_url
        type: string
        required: false
      - name: year
        type: integer
        required: false
      - name: tags
        type: array
        required: false
        own-table: true
  researchers:
    fields:
      - name: id
        type: string
        required: true
      - name: name
        type: string
        required: true
      - name: institution
        type: string
        required: false
      - name: region_id
        type: string
        required: true
      - name: specialisation
        type: string
        required: false
  regions:
    fields:
      - name: id
        type: string
        required: true
      - name: name
        type: string
        required: true
      - name: notes
        type: string
        required: false
  gaps:
    fields:
      - name: id
        type: string
        required: true
      - name: description
        type: string
        required: true
      - name: regions
        type: string
        required: false
  meta_analyses:
    fields:
      - name: id
        type: string
        required: true
      - name: title
        type: string
        required: true
      - name: summary
        type: string
        required: false
      - name: region_id
        type: string
        required: false
---

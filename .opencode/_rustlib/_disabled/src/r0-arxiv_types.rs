// ring: 0 (PURE)
//! Arxiv metadata type

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct ArxivEntry {
    pub id: String,
    pub title: String,
    pub summary: String,
    pub published: String,
    pub authors: Vec<String>,
    pub category: String,
    #[serde(skip_serializing_if = "Option::is_none", rename = "pdfUrl")]
    pub pdfurl: Option<String>,
    #[serde(rename = "absUrl")]
    pub absurl: String,
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct ArxivQuery {
    pub query: String,
    #[serde(rename = "maxResults")]
    pub maxresult: u32,
    pub category: Option<String>,
    #[serde(rename = "idList")]
    pub idlist: Option<String>,
    pub start: Option<u32>,
    #[serde(rename = "sortBy")]
    pub sortkey: Option<String>,
    #[serde(rename = "sortOrder")]
    pub sortorder: Option<String>,
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct ArxivReply {
    pub entries: Vec<ArxivEntry>,
    #[serde(rename = "totalResults")]
    pub totalresult: u32,
}
